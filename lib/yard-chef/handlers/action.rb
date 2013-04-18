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
        provider_obj = lwrp
        provider_obj.map_resource(statement.file)
        provider_obj.add_file(statement.file)

        # Add provider to the cookbook to which it belongs
        cookbook_obj = cookbook
        unless cookbook_obj.providers.include?(provider_obj)
          cookbook_obj.providers.push(provider_obj)
        end
        provider_obj.cookbook = cookbook_obj

        # Register the action in the provider
        action_obj = ChefObject.register(provider_obj, name, :action)
        action_obj.source = statement.source
        action_obj.docstring = statement.docstring
        action_obj.add_file(statement.file, statement.line)
      end
    end
  end
end
