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
require 'yard-chef/code_objects/attribute_object'
require 'yard-chef/code_objects/action_object'

require 'yard-chef/handlers/base'
require 'yard-chef/handlers/action'
require 'yard-chef/handlers/attribute'
require 'yard-chef/handlers/define'
require 'yard-chef/handlers/actions'
require 'yard-chef/handlers/cookbook'
require 'yard-chef/handlers/recipe'

module YARD::CodeObjects::Chef
  # Since 'recipe' files do not have a specific keyword that can be matched,
  # iterate through the list of files to be parsed and register the recipes.
  # Description for every recipe may be found in 'metadata.rb' which can
  # be taken care of in the handler.
  # TODO: Investigate if YARD handlers can be invoked if parser is in a
  # specific directory.
  YARD::Parser::SourceParser.before_parse_list do |files, globals|
    files.each do |file|
      path_arr = File.expand_path(file).to_s.split('/')
      unless (index = path_arr.index('recipes')).nil?
        # Cookbook name can be derived from file path
        # cookbook/<cookbook_name>/recipes/recipe_name.rb
        cookbook_name = path_arr[index - 1]
        cookbook = ChefObject.register(CHEF, cookbook_name, :cookbook)

        recipe_name = path_arr.last.to_s.sub('.rb','')
        recipe = ChefObject.register(cookbook, recipe_name, :recipe)

        recipe.source = IO.read(file)
        recipe.add_file(file, 1)
      end
    end
  end

  # Register '@resource' tag for mapping providers with light-weight resources
  YARD::Tags::Library.define_tag(
    'Map Chef Providers with Chef Resources',
    :resource
  )

  # Register template directory for the chef plugin
  template_dir = File.expand_path('../templates', File.dirname(__FILE__))
  YARD::Templates::Engine.register_template_path(template_dir.to_s)
end
