def init
  super
end

# Add yard-chef specific menus
# Methods generate_#{type}_list  must be defined in fulldoc/html/setup.rb
def menu_lists
[ { :type => 'cookbooks', :title => 'Cookbooks', :search_title => 'Cookbook List'},
  { :type => 'actions', :title => 'Actions', :search_title => 'Action List'},
  { :type => 'attributes', :title => 'Attributes', :search_title => 'Attribute List'},
  { :type => 'class', :title => 'Classes', :search_title => 'Class List' },
  { :type => 'method', :title => 'Methods', :search_title => 'Method List' },
  { :type => 'file', :title => 'Files', :search_title => 'File List' } ]
end
