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
  @page_title = page_title
  if @file
    if @file.attributes[:namespace]
      @object = options.object = Registry.at(@file.attributes[:namespace]) || Registry.root
    end
    @breadcrumb_title = 'File: ' + @file.title
    @page_title = 'Cookbook Documentation'
    sections :layout, [:title, %i[diskfile cookbook_table]]
  elsif object == '_index.html'
    sections :layout, [:title, [T('chef')]]
  end
end

# Add yard-chef specific menus
# Methods generate_#{type}_list  must be defined in fulldoc/html/setup.rb
def menu_lists
  [{ type: 'cookbooks', title: 'Cookbooks', search_title: 'Cookbook List' },
   { type: 'recipes', title: 'Recipes', search_title: 'Recipe List' },
   { type: 'resources', title: 'Resources', search_title: 'Resource List' },
   { type: 'definitions', title: 'Definitions', search_title: 'Definitions List' },
   { type: 'class', title: 'Libraries', search_title: 'Libraries List' }]
end

def page_title
  if object == '_index.html'
    'Cookbook Documentation'
  elsif object.is_a? CodeObjects::Base
    case object.type
    when :cookbook
      "Cookbook: #{object.name}"
    when :module, :class
      format_object_title(object)
    end
  end
end
