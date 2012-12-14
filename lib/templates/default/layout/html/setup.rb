def init
  super
  @page_title = page_title
  if @file
    if @file.attributes[:namespace]
      @object = options.object = Registry.at(@file.attributes[:namespace]) || Registry.root
    end
    @breadcrumb_title = "File: " + @file.title
    @page_title = "Cookbook Documentation"
    sections :layout, [:title, [:diskfile, :cookbook_table]]
  elsif object == '_index.html'
    sections :layout, [:title, [T('chef')]]
  end
end

# Add yard-chef specific menus
# Methods generate_#{type}_list  must be defined in fulldoc/html/setup.rb
def menu_lists
[ { :type => 'cookbooks', :title => 'Cookbooks', :search_title => 'Cookbook List'},
  { :type => 'recipes', :title => 'Recipes', :search_title => 'Recipe List'},
  { :type => 'resources', :title => 'Resources', :search_title => 'Resource List'},
  { :type => 'definitions', :title => 'Definitions', :search_title => 'Definitions List' },
  { :type => 'class', :title => 'Libraries', :search_title => 'Library List' } ]
end

def page_title
  if object == '_index.html'
    "Cookbook Documentation"
  elsif object.is_a? CodeObjects::Base
    case object.type
    when :cookbook
      "Cookbook: #{object.name}"
    when :module, :class
      format_object_title(object)
    end
  end
end
