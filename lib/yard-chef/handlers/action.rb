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
      
        # Find cookbook name from the file path
        ns_obj = YARD::Registry.resolve(:root, "#{CHEF_NAMESPACE}::#{path_arr[2].to_s}")

        name = statement.parameters.first.jump(:string_content, :ident).source
        #namespace = CookbookNameObject.findNamespace(path_arr[3].to_s)
        #cookbook_name = CookbookNameObject.fixName(path_arr[2].to_s)

        #ns_obj = YARD::Registry.resolve(:root, "#{namespace}::#{cookbook_name}")

        action_obj = ActionObject.new(ns_obj, name) do |action|
          action.source    = statement.source
          action.scope     = :instance
          action.docstring = statement.comments
          action.add_file(statement.file, statement.line)
        end
        register(action_obj)
        ns_obj.action.push(action_obj)
        log.info "Creating [Action] #{name} (#{action_obj.object_id}) => #{action_obj.path}"
        #puts("#{action_obj.docstring}")
        #puts("#{action_obj.source}")
        #puts("#{action_obj.files}")
        parse_block(statement.last.last, :owner => action_obj)
      end
    end
  
    class ActionHandler < YARD::Handlers::Ruby::Base
      include AbstractActionHandler
      handles method_call(:action)
    end

    module Legacy
      class ActionHandler < YARD::Handlers::Ruby::Legacy::Base
      end
    end
  end
end

