include T('default/module')
include YARD::Templates::Helpers::ModuleHelper

def init
  @cookbooks = get_cookbooks
  @actions = get_actions
  @attributes = get_attributes
  sections.push :lwrp
end

def get_cookbooks
  return YARD::Registry.all(:cookbook).sort_by {|cookbook| cookbook.name.to_s}
end

def get_actions
  return YARD::Registry.all(:action).uniq.sort_by {|action| action.namespace.to_s}
end

def get_attributes
  return YARD::Registry.all(:attribute).uniq.sort_by {|attrib| attrib.namespace.to_s}
end

def get_definitions
  return YARD::Registry.all(:definition).uniq.sort_by {|define| define.namespace.to_s}
end

# Returns items and unique namespaces of a particular cookbook
def get_items_of_cookbook(item_list, cookbook)
  list = []
  namespaces = []
  item_list.each do |item|
    if item.parent.namespace == cookbook or (item.type != :action and item.namespace == cookbook)
      list.push(item)
      namespaces.push(item.namespace)
    end
  end
  return list, namespaces.uniq {|name| name.to_s}
end

def item_listing(type)
  case type
  when :action
    @meths = get_items_of_cookbook(get_actions, object)
  when :attribute
    @meths = get_items_of_cookbook(get_attributes, object)
  when :definition
    @meths = get_items_of_cookbook(get_definitions, object)
  end
  #@meths = object.meths(:type => type, :included => !options.embed_mixins.empty?)
  #if options.embed_mixins.size > 0 
    #@meths = @meths.reject {|m| options.embed_mixins_match?(m.namespace) == false }
  #end 
  @meths[0] = sort_listing(prune_method_listing(@meths[0]))
  @meths
end
