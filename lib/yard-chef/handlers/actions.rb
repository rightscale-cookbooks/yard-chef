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
    class ActionsHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:actions)

      def process
        path_arr = parser.file.to_s.split("/")
        cookbook_name = path_arr[path_arr.index('resources') - 1]
        resource_name = path_arr[path_arr.index('resources') + 1].to_s.sub('.rb','')
        lwrp_name = LWRPObject.name(cookbook_name, resource_name)

        # Find the resource which lists the actions
        resource_obj = ResourceObject.register(lwrp_name)
        # if multiple actions listed in same line, split the actions and add them to the list
        if statement.first_line =~ /,/
          statement.first_line.split(%r{,?\s*:}).each do |action|
            resource_obj.actions.push(action)
          end
        else
          resource_obj.actions.push(statement.parameters.first.jump(:string_content, :ident).source)
        end

        log.info "Found [Actions] in #{parser.file.to_s}"
      end
    end
  end
end
