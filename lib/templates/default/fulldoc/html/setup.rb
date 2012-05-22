include YARD::Templates::Helpers::HtmlHelper

def init
  super
  # Generate page for Chef
  serialize(YARD::CodeObjects::Chef::CHEF_NAMESPACE)

  #@cookbook_elements = Registry.all(:cookbookelement)
  #@cookbook_elements.find_all.each do |child|
    #serialize(child)
  #end
  
  #TODO: need to generate lwrp.html
  @cookbooks = Registry.all(:cookbookname).sort_by{|cookbook| cookbook.name.to_s}
  @cookbooks.each do |cookbook|
    serialize(cookbook)
  end
  #generate_full_list(@cookbooks, "Cookbook", "cookbooks")
  
  #TODO: Don't understand why Registry.all() prints the same item thrice. Look into that

  generate_lwrp
  
  #erb(:action_table)  
  #@cookbooks.each do |cookbook|
    #puts cookbook.name
    #meth = items_of_type(cookbook, :action)
    #puts("Type: Actions")
    #puts meth
    #meth = items_of_type(cookbook, :attribute)
    #puts("Type: Attributes")
   # puts meth
    #cookbook.meths.each do |method|
     # puts method.name
    #end
  #end
  #cookbook_elements.each do |elements|
    #cookbook_names = elements.children
    #cookbook_names.find_all.each do |child|
      #serialize(child)
    #end
  #end
end

def items_of_type(cookbook, type)
  meth_arr = Array.new
  cookbook.meths.each do |method|
    meth_arr.push(method) if method.type == type
  end
  return meth_arr
end

def generate_lwrp
  #asset(url_for("lwrp"), erb(:lwrp))
  asset("lwrp.html", erb(:lwrp))
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_actions_list
  #TODO: Don't understand why Registry.all() prints the same item thrice. Look into that
  @actions = Registry.all(:action).uniq{|action| action.name.to_s}
  @actions = @actions.sort_by{|action| action.name.to_s}
  generate_full_list(@actions, "Action", "actions")
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_attributes_list
  @attributes = Registry.all(:attribute).uniq{|attribute| attribute.name.to_s}
  @attributes = @attributes.sort_by{|attribute| attribute.name.to_s}
  generate_full_list(@attributes, "Attribute", "attributes")
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_definitions_list
  @definitions = Registry.all(:definition).uniq{|define| define.name.to_s}
  @definitions = @definitions.sort_by{|define| define.name.to_s}
  generate_full_list(@definitions, "Definition", "definitions")
end

def generate_full_list(objects, title, type)
  @items = objects
  @list_title = "#{title} List"
  @list_type = "#{type}"
  generate_list_contents
end

def generate_list_content
  asset(url_for_list(@list_type), erb(:full_list))
end
