def init
  super
  @cookbooks = Registry.all(:cookbookname).sort_by{|cookbook| cookbook.name.to_s}

  # Generate page for Chef
  serialize(YARD::CodeObjects::Chef::CHEF)
  serialize(YARD::CodeObjects::Chef::LWRP)
  @cookbooks.each do |cookbook|
    serialize(cookbook)
  end
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_actions_list
  #TODO: Don't understand why Registry.all() prints the same item thrice. Look into that
  @actions = YARD::Registry.all(:action).uniq{|action| action.name.to_s}
  @actions = @actions.sort_by{|action| action.name.to_s}
  generate_full_list(@actions, "Action", "actions")
  #@actions.each do |action|
    #serialize(action)
  #end
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_attributes_list
  @attributes = YARD::Registry.all(:attribute).uniq.sort_by{|attribute| attribute.name.to_s}
  generate_full_list(@attributes, "Attribute", "attributes")
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
