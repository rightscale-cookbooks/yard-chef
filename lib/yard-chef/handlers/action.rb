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
        path_arr = parser.file.to_s.split("/")
        cookbook_path = path_arr.slice(path_arr.index("cookbooks"), path_arr.size)

        provider = resolve_namespace(cookbook_path)
        
        name = statement.parameters.first.jump(:string_content, :ident).source
        action_obj = ActionObject.new(provider, name) do |action|
          action.source    = statement.source
          action.docstring = statement.comments
          action.add_file(statement.file, statement.line)
        end
        log.info "Creating [Action] #{action_obj.name} #{action_obj.object_id} => #{action_obj.namespace}"
        parse_block(statement.last.last, :owner => action_obj)
      end

      def resolve_namespace(path_arr)
        cookbook = YARD::Registry.resolve(:root, "#{@@CHEF}::#{path_arr[1].to_s}")
        return YARD::Registry.resolve(:root, "#{@@PROVIDER}::#{cookbook.get_lwrp_name(path_arr[3].to_s)}")
      end

      def find_resource(path_arr)
        
      end
    end
  end
end
