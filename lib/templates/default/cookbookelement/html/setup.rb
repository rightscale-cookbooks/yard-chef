def init
  super
  @cookbooks = YARD::Registry.all(:cookbook).sort_by {|cookbook| cookbook.name.to_s}
  @actions = YARD::Registry.all(:action).uniq.sort_by {|action| action.namespace.to_s}
  @attributes = YARD::Registry.all(:attribute).uniq.sort_by {|attrib| attrib.namespace.to_s}
  sections.push :lwrp
end


# Returns items and unique namespaces of a particular cookbook
def get_items_of_cookbook(item_list, cookbook)
  list = []
  namespaces = []
  item_list.each do |item|
    if item.parent.namespace == cookbook
      list.push(item)
      namespaces.push(item.namespace)
    end
  end
  return list, namespaces.uniq {|name| name.to_s}
end
