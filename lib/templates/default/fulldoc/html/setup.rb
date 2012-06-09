include YARD::CodeObjects::Chef

def init
  super
  asset('css/common.css', file('css/common.css', true))

  #@cookbooks = Registry.all(:cookbook).sort_by{|cookbook| cookbook.name.to_s}
  @chef = object.child(:type => :chef)
  @@cookbooks = get_items_by_type(@chef, :cookbook)

  # Generate page for Chef
  serialize(@chef)

  # Generate a page for Recipes
  serialize(@chef.child(:type => :recipe))

  # Generate a page for Resources
  serialize(@chef.child(:type => :resource))
end

def get_items_by_type(object, type)
  items = Array.new()
  if not object.children.empty?
    object.children.each do |child|
      items.push(child) if child.type == type
    end
  end
  items.sort_by {|item| item.name.to_s}
end


# Called by menu_lists in layout/html/setup.rb by default
def generate_recipes_list
  @recipes = YARD::Registry.all(:recipe).uniq.sort_by {|recipe| recipe.name.to_s}
  generate_full_list(@recipes, "Recipe", "recipes")
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_resources_list
  @resources = YARD::Registry.all(:resource).uniq.sort_by{|resource| resource.name.to_s}
  generate_full_list(@resources, "Resource", "resources")
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_definitions_list
  @definitions = YARD::Registry.all(:definition).uniq.sort_by{|define| define.name.to_s}
  generate_full_list(@definitions, "Definition", "definitions")
end

def generate_cookbooks_list
  @cookbooks = YARD::Registry.all(:cookbook).sort_by{|cookbook| cookbook.name.to_s}
  generate_full_list(@cookbooks, "Cookbooks", "cookbooks")
end

def generate_full_list(objects, title, type)
  @items = objects
  @list_title = "#{title} List"
  @list_type = "#{type}"
  generate_list_contents
end

def generate_list_contents
  asset(url_for_list(@list_type), erb(:full_list))
end

def generate_class_list
  @items = YARD::Registry.all(:class).sort_by{|cl| cl.name.to_s}
  @list_title = "Class List"
  @list_type = "class"
  generate_list_contents
end

def link_object(object, title = nil)
  return title if title
  case object
  when YARD::CodeObjects::Base, YARD::CodeObjects::Proxy
    object.namespace
  when String, Symbol
    P(object).path
  else
    object
  end 
end 
