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
    class AttributeHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:attribute)
      
      def process
        path_arr = parser.file.to_s.split('/')
        if path_arr.include?('metadata.rb')
          cookbook_name = path_arr[path_arr.index('metadata.rb') - 1]
          namespace = CookbookObject.register(cookbook_name)
        else
          cookbook_name = path_arr[path_arr.index('resources') - 1]
          resource_name = path_arr[path_arr.index('resources') + 1].to_s.sub('.rb','')
          lwrp_name = LWRPObject.name(cookbook_name, resource_name)
          namespace = ResourceObject.register(lwrp_name)
        end
      
        name = statement.parameters.first.jump(:string_content, :ident).source
        attrib_obj = AttributeObject.new(namespace, name) do |attrib|
          attrib.source     = statement.source
          attrib.scope      = :instance
          attrib.docstring  = statement.comments
          attrib.add_file(statement.file, statement.line)
        end
        log.info "Created [Attribute] #{attrib_obj.name} => #{attrib_obj.namespace}"
      end
    end
  end
end
