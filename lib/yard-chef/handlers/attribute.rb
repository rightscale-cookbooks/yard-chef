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
      handles method_call(:attribute)

      # Process "attribute" keyword.
      #
      def process
        # If file path includes metadata then handle cookbook attributes
        # else handle resource attributes
        if parser.file =~ /metadata\.rb/
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
        attrib_obj = ChefObject.register(namespace, name, :attribute)
        attrib_obj.source = statement.source
        attrib_obj.docstring = docstring
        attrib_obj.add_file(statement.file, statement.line)
      end

      # Get the docstring related to the attributes. The docstring is obtained
      # from the ":description" field in the attribute.
      #
      # @return [YARD::Docstring] docstring for the attribute
      #
      def docstring
        description = ""
        path_array = parser.file.to_s.split('/')
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
        YARD::DocstringParser.new.parse(description).to_docstring
      end
    end
  end
end
