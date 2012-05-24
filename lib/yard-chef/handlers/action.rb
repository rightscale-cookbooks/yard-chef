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
    
    module AbstractActionHandler
      include YARD::CodeObjects::Chef
      def process
        path_arr = parser.file.to_s.split("/")
      
        # Find namespace for the action
        ns_obj = resolve_namespace(path_arr)

        name = statement.parameters.first.jump(:string_content, :ident).source

        action_obj = ActionObject.new(ns_obj, name) do |action|
          action.source    = statement.source
          action.scope     = :instance
          action.docstring = statement.comments
          action.add_file(statement.file, statement.line)
        end
        log.info "Creating [Action] #{action_obj.name} => #{action_obj.path}"
        parse_block(statement.last.last, :owner => action_obj)
      end

      def resolve_namespace(path_arr)
        if path_arr[4].to_s == 'default.rb'
          return YARD::Registry.resolve(:root, "#{CHEF}::#{path_arr[2].to_s}::#{path_arr[2].to_s}")
        else
          return YARD::Registry.resolve(:root, "#{CHEF}::#{path_arr[2].to_s}::#{path_arr[2].to_s}_#{path_arr[4].to_s.split('.')[0]}")
        end
      end
    end
  
    class ActionHandler < YARD::Handlers::Ruby::Base
      include AbstractActionHandler
      handles method_call(:action)
    end
  end
end
