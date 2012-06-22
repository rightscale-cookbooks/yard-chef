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

require 'yard-chef/code_objects/chef_objects'

require 'yard-chef/handlers/action'
require 'yard-chef/handlers/attribute'
require 'yard-chef/handlers/define'
require 'yard-chef/handlers/actions'
require 'yard-chef/handlers/recipe'
require 'yard-chef/handlers/cookbook_desc'

include YARD::CodeObjects::Chef
YARD::Parser::SourceParser.before_parse_list do |files, globals|
  flag = true
  files.each do |file|
    path_arr = file.to_s.split('/')
    if path_arr.include?('metadata.rb')
      if flag
        top_level_readme(path_arr)
        flag = false
      end
      register_cookbook(path_arr)
    elsif path_arr.include?('providers')
      register_lwrp(path_arr, 'providers')
    elsif path_arr.include?('resources')
      register_lwrp(path_arr, 'resources')
    elsif path_arr.include?('recipes')
      register_recipe(path_arr)
    elsif path_arr.include?('libraries')
      register_library(path_arr)
    end
  end
end

YARD::Tags::Library.define_tag('Map Chef Providers with Chef Resources', :resource)
YARD::Templates::Engine.register_template_path(File.join(File.dirname(__FILE__), 'templates'))

# Map providers with resources
YARD::Parser::SourceParser.after_parse_list do
  providers = PROVIDER.children_by_type(:provider)
  RESOURCE.children_by_type(:resource).each do |resource|
      resource.map_providers(providers)
  end
end
