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
    class AttributeHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:attribute)

      def process
        path_arr = parser.file.to_s.split('/')

        # If file path includes metadata then handle cookbook attributes
        # else handle resource attributes
        if path_arr.include?('metadata.rb')
          cookbook_name = path_arr[path_arr.index('metadata.rb') - 1]
          namespace = ChefObject.register(CHEF, cookbook_name, :cookbook)
        else
          resource_idx = path_arr.index('resources')
          cookbook_name = path_arr[resource_idx - 1]
          resource_name = path_arr[resource_idx + 1].to_s.sub('.rb','')

          lwrp_name = resource_name == 'default' ? cookbook_name : "#{cookbook_name}_#{resource_name}"

          # Register lightweight resource if not already registered
          namespace = ChefObject.register(RESOURCE, lwrp_name, :resource)
          namespace.add_file(statement.file)

          # Get cookbook to which the lightweight resource must belong
          cookbook_obj = ChefObject.register(CHEF, cookbook_name, :cookbook)
          cookbook_obj.resources.push(namespace) unless cookbook_obj.resources.include?(namespace)
        end

        # Register attribute if not already registered
        attrib_name = statement.parameters.first.jump(:string_content, :ident).source
        attrib_obj = ChefObject.register(namespace, attrib_name, :attribute)
        attrib_obj.source = statement.source
        attrib_obj.docstring = statement.comments
        attrib_obj.add_file(statement.file, statement.line)
      end
    end
  end
end
