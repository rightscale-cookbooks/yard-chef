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
      def initialize(namespace, name)
        super(namespace, name)
      end
    end

    class ProviderObject < ChefObject ; end
    class RecipeObject < ChefObject ; end
    class LibraryObject < ChefObject ; end

    class ResourceObject < ChefObject
      def initialize(namespace, name)
        super(namespace, name)
      end
    end
      
    class CookbookObject < ChefObject
      attr_accessor :resources, :providers, :attributes, :recipes
      def initialize(namespace, name)
        super(namespace, name)
        @resources = @providers = @attributes = @recipes = Array.new()
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

    # Register 'root' namespace as Chef
    # Read 'README.rdoc' file in the top level if available
    # Assumption: User must input relative path to the cookbooks
    YARD::Parser::SourceParser.before_parse_list do |files, globals|
      path_arr = files[0].split('/')
      @@CHEF = ChefObject.new(:root, "Chef")
      log.info "Creating [Chef] as root namespace"
      readme_file = path_arr.slice(0, path_arr.index("cookbooks"))
      if readme_file.empty?
        readme_file = './README.rdoc'
      else
        readme_file = readme_file.join('/') + '/README.rdoc'
      end
      @@CHEF.docstring = IO.read(readme_file) if File.exists?(readme_file)

      RESOURCE = ResourceObject.new(@@CHEF, "Resource")
      PROVIDER = ProviderObject.new(@@CHEF, "Provider")
      RECIPE = RecipeObject.new(@@CHEF, "Recipe")

      files.each do |file|
        path_arr = file.to_s.split('/')
        cookbook_path = path_arr.slice(path_arr.index("cookbooks"), path_arr.size)

        # Register Cookbooks
        cookbook = CookbookObject.new(@@CHEF, cookbook_path[1].to_s)
        readme_file = path_arr.slice(0, path_arr.size-1).join('/') + '/README.rdoc'
        cookbook.docstring = IO.read(readme_file) if File.exists?(readme_file)
        cookbook.add_file(file)
        log.info "Creating [Cookbook] #{cookbook.name} => #{cookbook.namespace}"

        # Register providers, resources, recipes
        case cookbook_path[2].to_s
        when 'providers'
          provider = ProviderObject.new(PROVIDER, cookbook.get_lwrp_name(cookbook_path[3].to_s))
          log.info "Creating [Provider] #{provider.name} => #{provider.namespace}"
        when 'resources'
          resource = ResourceObject.new(RESOURCE, cookbook.get_lwrp_name(cookbook_path[3].to_s))
          log.info "Creating [Resource] #{resource.name} => #{resource.namespace}"
        when 'recipes'
          recipe = RecipeObject.new(cookbook, cookbook_path[3].to_s.sub('.rb', ''))
          recipe.source = IO.read(file)
          recipe.add_file(file)
          log.info "Creating [Recipe] #{recipe.name} => #{recipe.namespace}"
        end
      end
    end
  end
end
