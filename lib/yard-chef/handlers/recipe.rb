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
    # Handles "recipes" in a cookbook.
    class RecipeHandler < Base
      handles method_call(:recipe)

      def process
        return unless is_metadata?(file)

        cookbook_obj = CookbookObject.register(COOKBOOK, get_cookbook_name(file))
        recipe_obj = RecipeObject.register(cookbook_obj, name)
        recipe_obj.docstring = docstring if recipe_obj.docstring.empty?
      end

      # Gets the recipe name from the metadata.rb.
      #
      # @return [String] the recipe name
      #
      def name
        recipe = super
        recipe = recipe.split("::")[1] if recipe =~ /::/
        recipe = 'default' if recipe == get_cookbook_name(file)
        recipe
      end

      # Gets the docstring for the recipe from the description field in the
      # 'recipe' keyword in the metadata.rb.
      #
      # @return [YARD::Docsting] the docstring
      #
      def docstring
        description = traverse(statement.parameters[1])
        YARD::DocstringParser.new.parse(description).to_docstring
      end
    end
  end
end
