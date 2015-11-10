# Copyright (c) 2015 Aleksey Hariton
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

module YARD::CodeObjects
  module Chef
    # A RecipeObject represents a recipe in a chef cookbook.
    # See http://docs.opscode.com/essentials_cookbook_recipes.html
    #
    class DependencyObject < ChefObject
      register_element :depends

      # Creates a new instance of RecipeObject.
      #
      # @param namespace [NamespaceObject] namespace to which the recipe belongs
      # @param name [String] name of the recipe
      #
      # @return [RecipeObject] the newly created RecipeObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @short_desc = ""
      end

      # Prefixes recipe name with the name of the cookbook.
      #
      # @return [String] recipe name
      #
      def name
        self.parent.name.to_s << '::' << @name.to_s
      end
    end
  end
end
