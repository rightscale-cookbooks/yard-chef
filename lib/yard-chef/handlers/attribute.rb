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
        cookbook_obj = CookbookObject.register(COOKBOOK, get_cookbook_name(file))
        if is_metadata?(file)
          namespace = cookbook_obj
        else
          namespace = ResourceObject.register(RESOURCE, lwrp_name(file))
          namespace.add_file(statement.file)

          cookbook_obj.resources |= [namespace]
        end

        # Register attribute if not already registered
        attrib_obj = AttributeObject.register(namespace, name)
        attrib_obj.source = source
        attrib_obj.docstring = docstring
        attrib_obj.add_file(file, line_number)
      end

      # Get the docstring related to the attributes. The docstring is obtained
      # from the ":description" field in the attribute.
      #
      # @return [YARD::Docstring] docstring for the attribute
      #
      def docstring
        description = ""
        if is_metadata?(file)
          statement.parameters[1].children.each do |ast_node|
            description << traverse(ast_node) if ast_node.jump(:ident).source == "description"
          end
        else
          description = statement.comments
        end
        YARD::DocstringParser.new.parse(description).to_docstring
      end
    end
  end
end
