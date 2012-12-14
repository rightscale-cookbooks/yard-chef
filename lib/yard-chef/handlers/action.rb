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
    # Handles "action" in a provider.
    class ActionHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:action)

      def process
        # Get cookbook and lightweight provider name from the file path
        path_arr = parser.file.to_s.split('/')
        provider_idx = path_arr.index('providers')
        cookbook_name = path_arr[provider_idx - 1]
        provider_name = path_arr[provider_idx + 1].to_s.sub('.rb','')

        # Construct lightweight provider name in lwrp format
        lwrp_name = provider_name == 'default' ? cookbook_name : "#{cookbook_name}_#{provider_name}"

        # Register lightweight provider if not already registered
        provider_obj = ChefObject.register(PROVIDER, lwrp_name, :provider)
        provider_obj.map_resource(parser.file)
        provider_obj.add_file(parser.file)

        # Add provider to the cookbook to which it belongs
        cookbook_obj = ChefObject.register(CHEF, cookbook_name, :cookbook)
        cookbook_obj.providers.push(provider_obj) unless cookbook_obj.providers.include?(provider_obj)
        provider_obj.cookbook = cookbook_obj

        # Register action if not already registered
        action_name = statement.parameters.first.jump(:string_content, :ident).source
        action_obj = ChefObject.register(provider_obj, action_name, :action)
        action_obj.source = statement.source
        action_obj.docstring = statement.comments
        action_obj.add_file(statement.file, statement.line)
      end
    end
  end
end
