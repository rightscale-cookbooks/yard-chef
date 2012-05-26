include T('default/cookbook/html')

def init
  @cookbooks = get_item_list(:cookbook)
  sections.push :lwrp
end

def get_item_list(type)
  return YARD::Registry.all(type).sort_by {|item| item.name.to_s}
end
