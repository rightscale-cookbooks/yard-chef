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
    class ActionHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:action)

      def process
        path_arr = parser.file.to_s.split('/')

        cookbook_name = path_arr[path_arr.index('providers') - 1]
        cookbook_obj = ChefObject.register(CHEF, cookbook_name, :cookbook)

        provider_name = path_arr[path_arr.index('providers') + 1].to_s.sub('.rb','')
        # Get the provider in LWRP name format. See http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+%28LWRP%29.
        lwrp_name = LWRPObject.name(cookbook_name, provider_name)
        provider_obj = ChefObject.register(PROVIDER, lwrp_name, :provider)
        provider_obj.read_tag(parser.file)
        provider_obj.add_file(parser.file)

        cookbook_obj.providers.push(provider_obj) unless cookbook_obj.providers.include?(provider_obj)

        action_name = statement.parameters.first.jump(:string_content, :ident).source
        action_obj = ChefObject.register(provider_obj, action_name, :action)
        action_obj.source = statement.source
        action_obj.docstring = statement.comments
        action_obj.add_file(statement.file, statement.line)
      end
    end
  end
end
