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

require 'yard-chef/handlers/action'
require 'yard-chef/handlers/attribute'
require 'yard-chef/handlers/define'
require 'yard-chef/handlers/actions'
require 'yard-chef/handlers/cookbook_desc'
require 'yard-chef/handlers/recipe'

module YARD::CodeObjects::Chef
  # Before parsing each file inside the specified cookbooks directory, register Chef elements like
  # "cookbooks", "definitions", "recipes" and "libraries" from file path names.
  YARD::Parser::SourceParser.before_parse_list do |files, globals|
    files.each do |file|
      # File path will be in this format "<cookbook_folder>/<cookbook_name>/<cookbook_elements>"
      # For example, "cookbooks/db/metadata.rb" or "./apache2/recipes/default.rb"
      path_arr = file.to_s.split('/')
      if path_arr.include?('metadata.rb')
        # Read top level README file
        CHEF.parse_readme(File.expand_path(file))

        # Register cookbook
        metadata_index = path_arr.index('metadata.rb')

        cookbook_name = path_arr[metadata_index - 1]
        cookbook = ChefObject.register(CHEF, cookbook_name, :cookbook)

        cookbook.parse_readme(File.expand_path(file))
        cookbook.add_file(path_arr[0 .. metadata_index - 1].join('/'))

      # Register recipe
      elsif path_arr.include?('recipes')
        recipe_index = path_arr.index('recipes')

        cookbook_name = path_arr[recipe_index - 1]
        cookbook = ChefObject.register(CHEF, cookbook_name, :cookbook)

        recipe_name = path_arr[recipe_index + 1].to_s.sub('.rb','')
        recipe = ChefObject.register(cookbook, recipe_name, :recipe)

        recipe.source = IO.read(file)
        recipe.add_file(file, 1)

      # Register definition
      elsif path_arr.include?('definitions')
        definition_index = path_arr.index('definitions')

        cookbook_name = path_arr[definition_index - 1]
        cookbook = ChefObject.register(CHEF, cookbook_name, :cookbook)

        definition_name = path_arr[definition_index + 1].to_s.sub('.rb','')
        definition = ChefObject.register(cookbook, definition_name, :definition)

        definition.add_file(file, 1)

      # Register library
      elsif path_arr.include?('libraries')
        cookbook_name = path_arr[path_arr.index('libraries') - 1]
        cookbook = ChefObject.register(CHEF, cookbook_name, :cookbook)

        cookbook.libraries.push(path_arr.join('/'))
      end
    end
  end

  YARD::Tags::Library.define_tag('Map Chef Providers with Chef Resources', :resource)
  YARD::Templates::Engine.register_template_path(File.join(File.dirname(__FILE__), 'templates'))
end
