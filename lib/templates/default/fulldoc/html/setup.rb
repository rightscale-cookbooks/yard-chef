def init
  super

  # Register custom stylesheets
  asset('css/common.css', file('css/common.css', true))

  # Generate cookbook pages
  chef = object.child(:type => :chef)
  cookbooks = chef.children_by_type(:cookbook)
  cookbooks.each do |cookbook|
    serialize(cookbook)
  end
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_recipes_list
  recipes = YARD::Registry.all(:recipe).uniq.sort_by {|recipe| recipe.name.to_s}
  generate_full_list(recipes, 'Recipe', 'recipes')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_resources_list
  cookbooks = YARD::Registry.all(:cookbook).uniq.sort_by {|cookbook| cookbook.name.to_s}
  generate_full_list(cookbooks, 'Resource', 'resources')
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
  libraries = options.objects if options.objects
  generate_full_list(libraries, 'Library', 'class')
end

def generate_full_list(objects, title, type)
  @items = objects
  @list_title = "#{title} List"
  @list_type = "#{type}"
  asset(url_for_list(@list_type), erb(:full_list))
end

def class_list(root = YARD::Registry.root)
  out = ""
  children = run_verifier(root.children)
  children.reject {|c| c.nil? }.sort_by {|child| child.path }.map do |child|
    if child.is_a?(CodeObjects::ModuleObject)
      name = child.name
      has_children = child.children.any? {|o| o.is_a?(CodeObjects::ModuleObject) }
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
      out << "<ul>#{class_list(child)}</ul>" if has_children
    end
  end
  out
end
