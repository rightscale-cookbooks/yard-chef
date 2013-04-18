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
    # A ChefObject is an abstract implementation of all chef elements
    # (cookbooks, resources, providers, recipes, attributes and actions).
    #
    class ChefObject < YARD::CodeObjects::ClassObject
      # Returns the formatting type of docstring (Example: :markdown, :rdoc).
      #
      # @return [Symbol, String] formatting type
      #
      attr_reader :docstring_type

      # Creates a new ChefObject object.
      #
      # @param namespace [NamespaceObject] namespace to which the object belongs
      # @param name [String] name of the ChefObject
      #
      # @return [ChefObject] the newly created ChefObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @docstring_type = :markdown
      end

      # Register a chef element class.
      #
      # @param element [Class] chef element class
      #
      def self.register_element(element)
        @@chef_elements ||= {}
        @@chef_elements[element] = self
      end

      # Factory for creating and registering chef element object in
      # YARD::Registry.
      #
      # @param namespace [NamespaceObject] namespace to which the object must
      # belong
      # @param name [String] name of the chef element
      # @param type [Symbol, String] type of the chef element
      #
      # @return [<type>Object] the element object
      #
      def self.register(namespace, name, type)
        element = @@chef_elements[type]
        if element
          element_obj = YARD::Registry.resolve(:root, "#{namespace}::#{name}")
          if element_obj.nil?
            element_obj = element.new(namespace, name)
            log.info "Created [#{type.to_s.capitalize}]" +
              " #{element_obj.name} => #{element_obj.namespace}"
          end
          element_obj
        else
          raise "Invalid chef element type #{type}"
        end
      end

      # Returns children of an object of a particular type.
      #
      # @param type [Symbol] type of ChefObject to be selected
      #
      # @return [Array<ChefObject>] list of ChefObjects
      #
      def children_by_type(type)
        children = YARD::Registry.all(type)
        children.reject { |child| child.parent != self }
      end

      # Gets all Chef cookbooks.
      #
      # @return [Array<CookbookObject>] list of cookbooks.
      #
      def cookbooks
        children_by_type(:cookbook)
      end
    end

    # Register 'Chef' as the root namespace
    CHEF = ChefObject.new(:root, 'chef')

    log.info "Creating [Chef] as 'root' namespace"
  end
end
