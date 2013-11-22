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

require 'yard-chef/code_objects/helpers/chef_helper'

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
  extend Helper

  YARD::Tags::Library.define_tag('Map Chef Providers with Chef Resources', :resource)
  YARD::Tags::Library.define_tag('Detailed description for recipes', :recipe)
  YARD::Tags::Library.define_tag('Documenting Chef Resources', :chef_resource)
  YARD::Tags::Library.define_tag('Documenting Chef Resource Attributes', :chef_resource_attribute)
  YARD::Tags::Library.define_tag('Supported Actions', :action)

  # Since 'recipe' files do not have a specific keyword that can be matched,
  # iterate through the list of files to be parsed and register the recipes.
  # Description for every recipe may be found in 'metadata.rb' which can
  # be taken care of in the handler.
  # TODO: Investigate if YARD handlers can be invoked if parser is in a
  # specific directory.
  YARD::Parser::SourceParser.before_parse_list do |files, globals|
    files.each do |file|
      if File.expand_path(file).to_s.split('/').include?('recipe')
        cookbook = CookbookObject.register(COOKBOOK, get_cookbook_name(file))

        recipe = RecipeObject.register(cookbook, get_object_name(file))
        recipe.source = IO.read(file)
        recipe.add_file(file, 1)
        recipe.docstring = IO.readlines(file)
      end
    end
  end

  YARD::Parser::SourceParser.after_parse_list do
    #YARD::Registry.all.each { |o| puts o.inspect }
    YARD::Registry.all(:class).each do |object|
      if object.tag(:chef_resource)
        resource = register_resource(object.tag(:chef_resource).text, object.file)
        resource.docstring = object.docstring

        object.tags(:action).each do |action_tag|
          #ActionObject.register(resource, action_tag.text)
          puts action_tag.text
        end

        object.meths.each do |method|
          if method.tag(:chef_resource_attribute)
            attribute_obj = AttributeObject.register(resource, method.name)
            attribute_obj.docstring = method.docstring
            attribute_obj.default_value = method.tag(:default).text if method.tag(:default)
            attribute_obj.actions = method.tag(:used_in_actions).text.split(%r{,\s*}) if method.tag(:used_in_actions)
          end
        end
      end
    end
    #YARD::Registry.all.each { |o| puts o.inspect }
  end

  # Register template directory for the chef plugin
  template_dir = File.expand_path('../templates', File.dirname(__FILE__))
  YARD::Templates::Engine.register_template_path(template_dir.to_s)
end
