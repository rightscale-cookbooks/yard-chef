include T('default/cookbook/html')

def init
  #sections.push T('module')
  if object.name.to_s == "RightScale"
    @cookbooks = get_item_list(:cookbook)
    sections.push :rightscale_desc, :lwrp
  else
    sections.push T('module')
  end
end

def get_item_list(type)
  return YARD::Registry.all(type).sort_by {|item| item.name.to_s}
end
