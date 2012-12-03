def init
  super
  @page_title = page_title
  if @file
    if @file.attributes[:namespace]
      @object = options.object = Registry.at(@file.attributes[:namespace]) || Registry.root
    end
    @breadcrumb_title = "File: " + @file.title
    @page_title = @breadcrumb_title
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
    @options.title
  elsif object.is_a? CodeObjects::Base
    case object.type
    when :cookbook
      "Cookbook: #{object.path}"
    when :recipe
      "Cookbook Recipes"
    when :resource
      "Chef Resources"
    when :provider
      "Chef Providers"
    when :definition
      "Chef Definitions"
    when :module, :class
      format_object_title(object)
    when :chef
      "Chef Home Page"
    end
  end
end
