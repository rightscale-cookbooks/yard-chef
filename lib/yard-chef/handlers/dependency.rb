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

module YARD::Handlers
  module Chef
    # Handles "recipes" in a cookbook.
    class DependencyHandler < Base
      handles method_call(:depends)

      def process
        path_array = statement.file.to_s.split('/')
        return unless path_array.include?('metadata.rb')

        # Recipe declaration in metadata.rb
        dependency_obj = ChefObject.register(cookbook, name, :dependency)
        dependency_obj.docstring = statement.docstring
      end

      # Gets the recipe name from the metadata.rb.
      #
      # @return [String] the recipe name
      #
      def name
        statement.parameters.first.jump(:string_content, :ident).source
      end

      # Gets the docstring for the recipe. The docstring is obtained from the
      # description field in the recipe.
      #
      # @return [YARD::Docsting] the docstring
      #
      def parse_docs
      end
    end
  end
end
