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
      
        name = statement.parameters.first.jump(:string_content, :ident).source
        action_obj = ActionObject.new(@@provider, name) do |action|
          action.source    = statement.source
          action.scope     = :instance
          action.docstring = statement.comments
          action.add_file(statement.file, statement.line)
        end
        log.info "Creating [Action] #{action_obj.name} #{action_obj.object_id} => #{action_obj.namespace}"
        parse_block(statement.last.last, :owner => action_obj)
      end
    end
  
    class ActionHandler < YARD::Handlers::Ruby::Base
      include AbstractActionHandler
      handles method_call(:action)
    end
  end
end
