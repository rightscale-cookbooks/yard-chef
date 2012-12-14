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
    # A ChefObject is the superclass of all chef elements (resources, providers, recipes, definitions, attributes and actions).
    class ChefObject < YARD::CodeObjects::ClassObject
      # Formatting type of README files (:markdown, :rdoc, etc.)
      # @return [Symbol] formatting type
      attr_reader :readme_type

      # Holds all implementations of Chef elements which is used by {self.register} factory method to create <chef_element>Object.
      @@chef_elements = {}

      # Creates a ChefObject instance and registers in YARD::Registry.
      # @param [NamespaceObject] namespace namespace to which the object must belong.
      # @param [String] name name of the ChefObject.
      def initialize(namespace, name)
        super(namespace, name)
        @readme_type = :markdown
      end

      # Register a Chef element Object class.
      # @param [Class] element Chef element object class.
      def self.register_element(element)
        @@chef_elements[element] = self
      end

      # Factory for creating Chef element Object instance and registering in YARD::Registry. New  Object instance created only it does not exist in YARD::Registry.
      # @param [NamespaceObject] namespace namespace to which the object must belong.
      # @param [String] name name of the Chef element Object.
      # @param [Symbol] type type of the Chef element Object.
      # @return [ChefObject] the Chef element Object instance.
      def self.register(namespace, name, type)
        element = @@chef_elements[type]
        if element
          element_obj = YARD::Registry.resolve(:root, "#{namespace}::#{name}")
          if element_obj.nil?
            element_obj = element.new(namespace, name)
            log.info "Created [#{type.to_s.capitalize}] #{element_obj.name} => #{element_obj.namespace}"
          end
          element_obj
        else
          raise "Invalid chef element type #{type}"
        end
      end

      # Parse README files if they exist in root repository folder.
      # @param [String] file_path path to the README file
      def parse_readme(file_path)
        path_arr = file_path.to_s.split('/')
        base_path = path_arr.slice(0..path_arr.index('metadata.rb')-3).join('/')

        # Check for README.rdoc file. If it does not exist, then look for README.md
        readme_path = base_path + '/README.rdoc'
        if File.exists?(readme_path)
          @docstring = YARD::DocstringParser.new.parse(IO.read(readme_path)).to_docstring if @docstring == ""
          @readme_type = :rdoc
        else
          readme_path = base_path + '/README.md'
          if File.exists?(readme_path)
            @docstring = YARD::DocstringParser.new.parse(IO.read(readme_path)).to_docstring if @docstring == ""
          end
        end
      end
      
      # Returns children of ChefObject of a particular type.
      # @param [Symbol] type type of ChefObject to be selected
      # @return [Array<ChefObject>] list of ChefObjects
      def children_by_type(type)
        children = []
        unless self.children.empty?
          self.children.each do |child|
            children.push(child) if child.type == type
          end
        end
        children.sort_by {|item| item.name.to_s}
      end
    end

    # Register 'Chef' as the root namespace

    # Root namespace
    CHEF = ChefObject.new(:root, 'Chef')

    log.info "Creating [Chef] as 'root' namespace"
  end
end
