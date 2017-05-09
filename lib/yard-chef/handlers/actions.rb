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
    # Handles list of actions in a lightweight resource.
    #
    class ActionsHandler < Base
      handles method_call(:actions)

      def process
        # Register the lightweight resource
        resource_obj = lwrp
        resource_obj.add_file(statement.file)

        # Add the lightweight resource to the cookbook in which it is defined
        cookbook_obj = cookbook
        unless cookbook_obj.resources.include?(resource_obj)
          cookbook_obj.resources.push(resource_obj)
        end

        # if multiple actions listed in same line, split the actions and
        # register them
        if statement.first_line =~ /,/
          statement.first_line.split(/,?\s*:/).each do |_action|
            action = ChefObject.register(resource_obj, name, :action)
          end
        else
          action = ChefObject.register(resource_obj, name, :action)
          action.docstring = statement.docstring
        end

        log.info "Found [Actions] in #{parser.file}"
      end
    end
  end
end
