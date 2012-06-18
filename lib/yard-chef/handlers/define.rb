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
    class DefinitionHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:define)
      
      def process
        path_arr = parser.file.to_s.split("/")
        cookbook = find_cookbook(path_arr[path_arr.index('definitions') - 1])

        name = statement.parameters.first.jump(:string_content, :ident).source

        define_obj = DefinitionObject.new(DEFINITION, name) do |define|
          define.source = statement.source
          define.docstring = statement.comments
          define.add_file(statement.file, statement.line)
        end
        
        log.info "Creating [Definition] #{define_obj.name} => #{define_obj.namespace}"
     end
    end
  end
end
