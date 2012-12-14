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
    # Handles definitions in a cookbook.
    class DefinitionHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:define)

      def process
        # Get cookbook and definition name from file path
        path_arr = parser.file.to_s.split('/')
        definition_idx = path_arr.index('definitions')
        cookbook_name = path_arr[definition_idx - 1]
        definition_name = path_arr[definition_idx + 1].to_s.sub('.rb','')

        # Get cookbook to which the definition must belong
        cookbook_obj = ChefObject.register(CHEF, cookbook_name, :cookbook)

        # Register definition if not already registered
        define_obj = ChefObject.register(cookbook_obj, definition_name, :definition)
        define_obj.source = statement.source
        define_obj.docstring = statement.comments
        define_obj.add_file(statement.file, statement.line)
      end
    end
  end
end
