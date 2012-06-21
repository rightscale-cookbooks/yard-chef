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
    class ChefObject < YARD::CodeObjects::ClassObject
      attr_accessor :Name, :Path
      def initialize(namespace, name)
        super(namespace, name)
      end

      def Name
        if self.parent.root?
          @Name = @name.to_s
        elsif @namespace.parent.root?
          @Name = @name.to_s.capitalize
        else
          @Name = @name.to_s
        end
        @Name
      end

      def Path
        if self.parent.root?
          @Path = @path
        elsif @namespace.parent.root?
          @Path = @namespace.name.to_s << '::' << self.Name
        else
          @Path = @namespace.parent.name.to_s << '::' << self.parent.Name << '::' << @name.to_s
        end
        @Path
      end

      def children_by_type(type)
        children = Array.new()
        if not self.children.empty?
          self.children.each do |child|
            children.push(child) if child.type == type
          end
        end
        children.sort_by {|item| item.name.to_s}
      end
    end
    CHEF = ChefObject.new(:root, 'Chef')
    log.info "Creating [Chef] as root namespace"

    class ProviderObject < ChefObject
      attr_accessor :resources

      def initialize(namespace, name)
        super(namespace, name)
        @resources = []
      end

      def read_tag(file)
        file_handle = File.open(File.expand_path(file), 'r')
        file_handle.readlines.each do |line|
          if line =~ /@resource/
            self.resources.push(line.split(%r{@resource })[1])
          end
        end
      end
    end
        
    PROVIDER = ProviderObject.new(CHEF, 'provider')
    log.info "Creating [Provider] namespace => #{PROVIDER.namespace}"

    class DefinitionObject < ChefObject ; end
    DEFINITION = DefinitionObject.new(CHEF, 'definition')
    log.info "Creating [Definition] namespace => #{DEFINITION.namespace}"

    class RecipeObject < ChefObject
      def Name
        @Name = self.parent.name.to_s << '::' << @name.to_s
        @Name
      end

      def Path
        @path
      end

      def get_recipe_name
        cookbook_name = self.parent.name.to_s
        cookbook_name == @name.to_s ? cookbook_name : cookbook_name << '::' << @name.to_s
      end
    end
    RECIPE = RecipeObject.new(CHEF, 'recipe')
    log.info "Creating [Recipe] namespace => #{RECIPE.namespace}"

    class ActionObject < ChefObject
      def Name
        @Name = @name
        @Name
      end

      def Path
        @Path = self.parent.Path << '::' << @name.to_s
        @Path
      end
    end

    class AttributeObject < ChefObject
      attr_accessor :default, :kind_of, :required, :regex, :equal_to, :name_attribute, :callbacks, :respond_to, :display_name, :description, :recipes, :choice

      def Name
        @Name = ''
        if @namespace.type == :cookbook
          if @name =~ /\//
            array = @name.to_s.split('/')
            array.each do |o|
              @Name = @Name << "[:#{o}]"
            end
          else
            @Name = @name
          end
        else
          @Name = @name
        end
        @Name
      end

      def Path
        @Path = @namespace.type == :cookbook ? @path : self.parent.Path << '::' << @name.to_s
        @Path
      end

      def get_attribute_name
        attrib_name = ''
        if @name =~ /\//
          array = @name.to_s.split('/')
          array.each do |o|
            attrib_name << "[:#{o}]"
          end
        else
          attrib_name = @name
        end
        attrib_name
      end    
    end

    class ResourceObject < ChefObject
      attr_accessor :actions, :providers
      def initialize(namespace, name)
        super(namespace, name)
        @actions = []
        @providers = []
      end

      def map_providers(providers_list)
        providers_list.each do |provider|
          if provider.resources.size > 0
            provider.resources.each do |res|
              if self.Path.to_s == res.strip
                self.providers.push(provider)
                break
              end
            end
          end
        end
      end
    end
    RESOURCE = ResourceObject.new(CHEF, 'resource')
    log.info "Creating [Resource] namespace => #{RESOURCE.namespace}"
      
    class CookbookObject < ChefObject
      attr_accessor :short_desc, :version, :resources, :libraries, :definitions
      def initialize(namespace, name)
        super(namespace, name)
        @resources = Array.new()
        @libraries = Array.new()
        @definitions = Array.new()
      end

      def Name
        @Name = @name.to_s
        @Name
      end

      def Path
        @Path = @path
        @Path
      end

      def get_lwrp_name(filename)
        if filename == 'default.rb'
          element_name = fix_underscores(@name.to_s)
        else
          element_name = fix_underscores(@name.to_s) << fix_underscores(filename.sub('.rb', ''))
        end
        element_name
      end

      def fix_underscores(name)
        fixed_name = ''
        if name =~ /_/
          name.split('_').each do |str|
            fixed_name << str.to_s.capitalize
          end
        else
          fixed_name = name.capitalize
        end
        fixed_name
      end
    end

    def find_cookbook(cookbook_name)
      YARD::Registry.resolve(:root, "#{CHEF}::#{cookbook_name}")
    end

    def register_cookbook(path_arr)
      # Get cookbook name from the path
      # By convention 'metadata.rb' should be at the top of the cookbook folder
      cookbook_name = path_arr[path_arr.index('metadata.rb') - 1]
      cookbook = CookbookObject.new(CHEF, cookbook_name)
      readme_file = path_arr.slice(0, path_arr.size-1).join('/') + '/README.rdoc'
      if File.exists?(File.expand_path(readme_file))
        cookbook.source = IO.read(File.expand_path(readme_file))
      end
      cookbook.add_file(path_arr.join('/'))
      log.info "Creating [Cookbook] #{cookbook.name} => #{cookbook.namespace}"
      cookbook
    end

    def register_lwrp(path_arr, type)
      cookbook = self.find_cookbook(path_arr[path_arr.index(type) - 1])
      lwrp_name = cookbook.get_lwrp_name(path_arr[path_arr.index(type) + 1])
      if type == 'providers'
        lwrp = ProviderObject.new(PROVIDER, lwrp_name)
        lwrp.read_tag(path_arr.join('/'))
      elsif type == 'resources'
        lwrp = ResourceObject.new(RESOURCE, lwrp_name)
        cookbook.resources.push(lwrp)
      end
      log.info "Creating [#{lwrp.type}] #{lwrp.name} => #{lwrp.namespace}"
      lwrp
    end

    def register_recipe(path_arr)
      cookbook = self.find_cookbook(path_arr[path_arr.index('recipes') - 1])
      recipe_name = path_arr[path_arr.index('recipes') + 1]
      recipe = RecipeObject.new(cookbook, recipe_name.to_s.sub('.rb', '')) do |o|
        o.source = IO.read(path_arr.join('/'))
        o.add_file(path_arr.join('/'))
      end
      log.info "Creating [Recipe] #{recipe.name} => #{recipe.namespace}"
      recipe
    end

    def register_library(path_arr)
      cookbook = self.find_cookbook(path_arr[path_arr.index('libraries') - 1])
      cookbook.libraries.push(path_arr.join('/'))
    end
  end
end
