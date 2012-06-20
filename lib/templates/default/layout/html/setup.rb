def init
  super
end

# Add yard-chef specific menus
# Methods generate_#{type}_list  must be defined in fulldoc/html/setup.rb
def menu_lists
[ { :type => 'cookbooks', :title => 'Cookbooks', :search_title => 'Cookbook List'},
  { :type => 'recipes', :title => 'Recipes', :search_title => 'Recipe List'},
  { :type => 'resources', :title => 'Resources', :search_title => 'Resource List'},
  { :type => 'definitions', :title => 'Definitions', :search_title => 'Definitions List' },
  { :type => 'libraries', :title => 'Libraries', :search_title => 'Library List' } ]
end
