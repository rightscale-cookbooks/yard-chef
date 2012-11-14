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

require 'yard-chef/code_objects/chef_object'
require 'yard-chef/code_objects/cookbook_object'
require 'yard-chef/code_objects/resource_object'
require 'yard-chef/code_objects/provider_object'
require 'yard-chef/code_objects/recipe_object'
require 'yard-chef/code_objects/definition_object'
require 'yard-chef/code_objects/attribute_object'
require 'yard-chef/code_objects/action_object'
require 'yard-chef/code_objects/lwrp_object'

require 'yard-chef/handlers/action'
require 'yard-chef/handlers/attribute'
require 'yard-chef/handlers/define'
require 'yard-chef/handlers/actions'
require 'yard-chef/handlers/cookbook_desc'

module YARD::CodeObjects::Chef
  # Before parsing each file inside the specified cookbooks directory, register Chef elements like
  # "resources", "providers", "recipes" and "libraries" from file path names.
  # For example,
  # cookbooks/<cookbook_name>/resources/<resource_name>.rb - Register "resource_name" under "cookbook_name"
  # cookbooks/<cookbook_name>/providers/<provider_name>.rb - Register "provider_name" under "cookbook_name"
  YARD::Parser::SourceParser.before_parse_list do |files, globals|
    files.each do |file|
      # File path will be in this format "<cookbook_folder>/<cookbook_name>/<cookbook_elements>"
      # For example, "cookbooks/db/metadata.rb" or "./apache2/recipes/default.rb"
      path_arr = file.to_s.split('/')
      if path_arr.include?('metadata.rb')
        # Read top level README file
        CHEF.parse_readme(File.expand_path(file))

        # Register cookbook
        cookbook_name = path_arr[path_arr.index('metadata.rb') - 1]
        cookbook = CookbookObject.register(cookbook_name)
        cookbook.parse_readme(File.expand_path(file))
        cookbook.add_file(file)

      elsif path_arr.include?('providers')
        # Register provider
        cookbook_name = path_arr[path_arr.index('providers') - 1]
        provider_name = path_arr[path_arr.index('providers') + 1].to_s.sub('.rb','')
        # Get the provider in LWRP name format. See http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+%28LWRP%29.
        cookbook = CookbookObject.register(cookbook_name)
        lwrp_name = LWRPObject.name(cookbook_name, provider_name)
        provider = ProviderObject.register(lwrp_name)
        provider.add_file(file)
        log.info "Created [Provider] #{provider.name} => #{provider.namespace}"
        cookbook.providers.push(provider)

      elsif path_arr.include?('resources')
        # Register resource
        cookbook_name = path_arr[path_arr.index('resources') - 1]
        resource_name = path_arr[path_arr.index('resources') + 1].to_s.sub('.rb','')
        cookbook = CookbookObject.register(cookbook_name)
        # Get the resource in LWRP name format. See http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+%28LWRP%29.
        lwrp_name = LWRPObject.name(cookbook_name, resource_name)
        resource = ResourceObject.register(lwrp_name)
        resource.add_file(file)
        log.info "Created [Resource] #{resource.name} => #{resource.namespace}"
        cookbook.resources.push(resource)

      elsif path_arr.include?('recipes')
        # Register recipe
        cookbook_name = path_arr[path_arr.index('recipes') - 1]
        recipe_name = path_arr[path_arr.index('recipes') + 1].to_s.sub('.rb','')
        cookbook = CookbookObject.register(cookbook_name)
        recipe = RecipeObject.new(cookbook, recipe_name) do |recipe_obj|
          recipe_obj.source = IO.read(file)
          recipe_obj.add_file(file)
        end
        log.info "Created [Recipe] #{recipe.name} => #{recipe.namespace}"

      elsif path_arr.include?('definitions')
        # Register definition
        cookbook_name = path_arr[path_arr.index('definitions') - 1]
        definition_name = path_arr[path_arr.index('definitions') + 1].to_s.sub('.rb','')
        cookbook = CookbookObject.register(cookbook_name)
        definition = DefinitionObject.new(cookbook, definition_name) do |definition_obj|
          definition_obj.add_file(file)
        end
        log.info "Created [Definition] #{definition.name} => #{definition.namespace}"

      elsif path_arr.include?('libraries')
        # Register library
        cookbook_name = path_arr[path_arr.index('libraries') - 1]
        cookbook = CookbookObject.register(cookbook_name)
        cookbook.libraries.push(path_arr.join('/'))
      end
    end
  end

  YARD::Tags::Library.define_tag('Map Chef Providers with Chef Resources', :resource)
  YARD::Templates::Engine.register_template_path(File.join(File.dirname(__FILE__), 'templates'))

  # Map providers with resources
  YARD::Parser::SourceParser.after_parse_list do
    #YARD::Registry.each do |obj|
      #puts obj.inspect, obj.namespace
    #end
    #providers = PROVIDER.children_by_type(:provider)
    #RESOURCE.children_by_type(:resource).each do |resource|
        #resource.map_providers(providers)
    #end
  end
end
