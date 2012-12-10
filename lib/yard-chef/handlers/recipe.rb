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
    class RecipeHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:recipe)

      def process
        path_arr = parser.file.to_s.split('/')

        cookbook_name = path_arr[path_arr.index('metadata.rb') - 1] if path_arr.include?('metadata.rb')
        cookbook = ChefObject.register(CHEF, cookbook_name, :cookbook)

        recipe_name = statement.parameters.first.jump(:string_content).source
        recipe_obj = ChefObject.register(cookbook, recipe_name, :recipe)
        recipe_obj.docstring = statement.parameters[1]
      end
    end
  end
end
