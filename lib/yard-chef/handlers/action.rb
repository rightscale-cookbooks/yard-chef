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
    #
    class ActionHandler < Base
      handles method_call(:action)

      def process
        # Register the provider object
        provider_obj = ProviderObject.register(PROVIDER, lwrp_name(file))
        provider_obj.add_file(file)
        provider_obj.map_resource(file)

        # Add provider to the cookbook to which it belongs
        cookbook_obj = CookbookObject.register(COOKBOOK, get_cookbook_name(file))
        cookbook_obj.providers |= provider_obj
        provider_obj.cookbook = cookbook_obj

        # Register the action in the provider
        action_obj = ActionObject.register(provider_obj, name)
        action_obj.source = source
        action_obj.docstring = docstring
        action_obj.add_file(file, line)
      end
    end
  end
end
