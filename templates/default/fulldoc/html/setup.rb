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

def init
  super

  # Register custom stylesheets
  asset('css/common.css', file('css/common.css', true))

  # Generate cookbook pages
  chef = YARD::Registry.all(:chef).first
  chef.cookbooks.each do |cookbook|
    serialize(cookbook)
  end
end

# Generates searchable recipe list in the output.
#
def generate_recipes_list
  recipes = YARD::Registry.all(:recipe).sort_by { |recipe| recipe.name.to_s }
  generate_full_list(recipes, 'Recipe', 'recipes')
end

# Generates searchable resource list in the output.
#
def generate_resources_list
  cookbooks = YARD::Registry.all(:cookbook).sort_by { |cookbook| cookbook.name.to_s }
  generate_full_list(cookbooks, 'Resource', 'resources')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_definitions_list
  cookbooks = YARD::Registry.all(:cookbook).sort_by { |cookbook| cookbook.name.to_s }
  definitions = []
  cookbooks.each { |cookbook| definitions += cookbook.definitions }
  generate_full_list(definitions, 'Definition', 'definitions')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_cookbooks_list
  cookbooks = YARD::Registry.all(:cookbook).sort_by { |cookbook| cookbook.name.to_s }
  generate_full_list(cookbooks, 'Cookbooks', 'cookbooks')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_libraries_list
  libraries = options.objects if options.objects
  generate_full_list(libraries, 'Library', 'class')
end

def generate_full_list(objects, title, type)
  @items = objects
  @list_title = "#{title} List"
  @list_type = type.to_s
  asset(url_for_list(@list_type), erb(:full_list))
end

def class_list(root = YARD::Registry.root)
  out = ''
  children = run_verifier(root.children)
  children.reject(&:nil?).sort_by(&:path).map do |child|
    next unless child.is_a?(CodeObjects::ModuleObject)
    name = child.name
    has_children = child.children.any? { |o| o.is_a?(CodeObjects::ModuleObject) }
    out << '<li>'
    out << "<a class='toggle'></a> " if has_children
    out << linkify(child, name)
    out << " &lt; #{child.superclass.name}" if child.is_a?(CodeObjects::ClassObject) && child.superclass
    out << "<small class='search_info'>"
    out << if !child.namespace || child.namespace.root?
             'Top Level Namespace'
           else
             child.namespace.path
           end
    out << '</small>'
    out << '</li>'
    out << "<ul>#{class_list(child)}</ul>" if has_children
  end
  out
end
