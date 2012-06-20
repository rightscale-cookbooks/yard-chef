def init
  super
  asset('css/common.css', file('css/common.css', true))

  chef = object.child(:type => :chef)
  @@cookbooks = chef.children_by_type(:cookbook)

  # Generate page for Chef
  serialize(chef)

  # Generate a page for Recipes
  recipe = chef.child(:type => :recipe)
  serialize(recipe)

  # Generate a page for Resources
  resource = chef.child(:type => :resource)
  serialize(resource)

  # Generate a page for Providers
  provider = chef.child(:type => :provider)
  serialize(provider)

  # Generate a page for Definitions
  definition = chef.child(:type => :definition)
  serialize(definition)

  # Generate cookbook pages
  @@cookbooks.each do |cookbook|
    serialize(cookbook)
  end
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
  recipes = YARD::Registry.all(:recipe).uniq.sort_by {|recipe| recipe.name.to_s}
  generate_full_list(recipes, 'Recipe', 'recipes')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_resources_list
  resources = YARD::Registry.all(:resource).uniq.sort_by {|resource| resource.name.to_s}
  generate_full_list(resources, 'Resource', 'resources')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_definitions_list
  definitions = YARD::Registry.all(:definition).uniq.sort_by{|define| define.name.to_s}
  generate_full_list(definitions, 'Definition', 'definitions')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_cookbooks_list
  cookbooks = YARD::Registry.all(:cookbook).uniq.sort_by{|cookbook| cookbook.name.to_s}
  generate_full_list(cookbooks, 'Cookbooks', 'cookbooks')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_libraries_list
  libraries = YARD::Registry.all(:class).sort_by {|lib| lib.name.to_s}
  generate_full_list(libraries, 'Library', 'libraries')
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

def libraries_list(root = Registry.root)
  out = ""
  children = run_verifier(root.children)
  if root == Registry.root
    children += @items.select {|o| o.namespace.is_a?(CodeObjects::Proxy) }
  end
  children.reject {|c| c.nil? }.sort_by {|child| child.path }.map do |child|
    if child.is_a?(CodeObjects::ModuleObject)
      name = child.namespace.is_a?(CodeObjects::Proxy) ? child.path : child.name
      has_children = child.children.any? {|o| o.is_a?(CodeObjects::NamespaceObject) }
      out << "<li>"
      out << "<a class='toggle'></a> " if has_children
      out << linkify(child, name)
      out << " &lt; #{child.superclass.name}" if child.is_a?(CodeObjects::ClassObject) && child.superclass
      out << "<small class='search_info'>"
      if !child.namespace || child.namespace.root?
        out << "Top Level Namespace"
      else
        out << child.namespace.path
      end
      out << "</small>"
      out << "</li>"
      out << "<ul>#{libraries_list(child)}</ul>" if has_children
    end
  end
  out
end
