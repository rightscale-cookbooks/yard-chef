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
      handles method_call(:add_action)

      def process
        path_arr = parser.file.to_s.split("/")

        # Find the resource which lists the actions
        ns_obj = resolve_namespace(path_arr)
        # if multiple actions listed in same line, split the actions and add them to the list
        if statement.first_line =~ /,/
          statement.first_line.split(%r{,?\s*:}).each do |action|
            ns_obj.actions.push(action) if action != 'actions'
          end
        else
          ns_obj.actions.push(statement.parameters.first.jump(:string_content, :ident).source)
        end

        log.info "Found [Actions] in #{parser.file.to_s} => #{ns_obj.actions}"
      end

      def resolve_namespace(path_arr)
        if path_arr[4].to_s == 'default.rb'
          return YARD::Registry.resolve(:root, "#{CHEF}::#{path_arr[2].to_s}::#{path_arr[2].to_s}")
        else
          return YARD::Registry.resolve(:root, "#{CHEF}::#{path_arr[2].to_s}::#{path_arr[2].to_s}_#{path_arr[4].to_s.split('.')[0]}")
        end
      end
    end
  end
end
