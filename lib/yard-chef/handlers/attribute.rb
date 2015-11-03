# Copyright (c) 2012 RightScale, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'yard'

module YARD::Handlers
  module Chef
    # Handles "attributes" in cookbook metadata and lightweight resource.
    #
    class AttributeHandler < Base
      MATCH = /^\s*(default|normal)(\[.+\])\s*=\s*(.+)/m
      handles method_call(:attribute)
      handles MATCH

      # Process "attribute" keyword.
      #
      def process
        path_array = parser.file.to_s.split('/')
        # If file path includes metadata then handle cookbook attributes
        # else handle resource attributes
        if path_array.include?('metadata.rb') || path_array.include?('attributes')
          namespace = cookbook
        else
          namespace = lwrp
          namespace.add_file(statement.file)

          cookbook_obj = cookbook
          unless cookbook_obj.resources.include?(namespace)
            cookbook_obj.resources.push(namespace)
          end
        end

        # Register attribute if not already registered
        if path_array.include? 'attributes'
          statement.source =~ MATCH
          attrib_obj = ChefObject.register(namespace, "node.#{$2}", :attribute)
        else
          attrib_obj = ChefObject.register(namespace, name, :attribute)
        end
        attrib_obj.source = statement.source
        attrib_obj.add_file(statement.file, statement.line)

        ############
        puts "############### KARAMBA!: #{statement.source}"

        # Parse docstring
        description = ""
        if path_array.include?('metadata.rb')
          # Suppose :description string have concatenation operator '+' then
          # YARD builds an abstract syntax tree (AST). We need to traverse the
          # tree to get the whole description string
          statement.parameters[1].children.each do |ast_node|
            if ast_node.jump(:ident).source == "description"
              ast_node.traverse do |child|
                description << child.jump(:string_content).source if child.type == :string_content
              end
            end
          end
        else
          description = statement.comments
        end
        attrib_obj.docstring = YARD::DocstringParser.new.parse(description).to_docstring
        _kind_of = ''
        _default = ''
        if path_array.include? 'attributes'
          statement.source =~ MATCH
          _default = $3
        else
          statement.parameters.each do |n|
            if (n.kind_of? YARD::Parser::Ruby::AstNode) && (n.source =~ /(default|kind_of)/)
              n.each do |node|
                if node.source =~ /default/
                  m =  node.source.match(/\W+?\s(.*)/)
                  _default = m[1] if m
                end
                if node.source =~ /kind_of/
                  m = node.source.match(/\W+?\s(.*)/)
                  _kind_of = m[1] if m
                end
              end
            end
          end
        end
        attrib_obj.kind_of = _kind_of
        attrib_obj.default = _default
      end
    end
  end
end
