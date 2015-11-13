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

module YARD::CodeObjects
  module Chef
    # A CookbookObject represents a Chef cookbook.
    # See http://wiki.opscode.com/display/chef/Cookbooks for more information
    # about cookbook.
    #
    class CookbookObject < ChefObject
      register_element :cookbook

      # Short description for the cookbook.
      #
      # @param short_desc [String] short description for the cookbook
      #
      # @return [String] short description for the cookbook
      #
      attr_accessor :short_desc

      # Version of the cookbook.
      #
      # @param version [String] version for the cookbook
      #
      # @return [String] version for the cookbook
      #
      attr_accessor :version

      # Lightweight resources implemented in the cookbook.
      #
      # @return [Array<ResourceObject>] lightweight resources in the cookbook
      #
      attr_reader :resources

      # Lightweight providers implemented in the cookbook.
      #
      # @return [Array<ProviderObject>] lightweight providers in the cookbook
      #
      attr_reader :providers

      # Creates a new CookbookObject instance.
      # @param namespace [NamespaceObject] namespace to which the cookbook
      # belongs
      # @param name [String] name of the cookbook
      #
      # @return [CookbookObject] the newly created CookbookObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @resources = []
        @providers = []
        @libraries = []
      end

      # Recipes implemented in the cookbook.
      #
      # @return [Array<RecipeObject>] recipes in the cookbook
      #
      def recipes
        children_by_type(:recipe)
      end

      # Attributes implemented in the cookbook.
      #
      # @return [Array<AttributeObject>] attributes in the cookbook
      #
      def attributes
        children_by_type(:attribute)
      end

      # Definitions implemented in the cookbook.
      #
      # @return [Array<MethodObject>] definitions in the cookbook
      #
      def definitions
        children_by_type(:method)
      end

      # Dependencies of the cookbook.
      #
      # @return [Array<MethodObject>] dependencies of the cookbook
      #
      def dependencies
        children_by_type(:dependency)
      end

      # Libraries defined in the cookbook.
      #
      # @return [Array<ModuleObject>] libraries in the cookbook
      #
      def libraries
        modules = YARD::Registry.all(:module)
        modules.select { |lib| !lib.parent.root? && lib.file =~ /#{@name}/ }
      end
    end
  end
end
