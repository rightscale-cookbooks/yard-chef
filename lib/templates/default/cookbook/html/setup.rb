include T('default/module')

def init
  sections.push :cookbook_desc
  sections.push :provider_summary, [:items]
  sections.push :resource_summary, [:items]
  sections.push :definition_summary, [:items]
  sections.push :provider_details, [T('method_details')]
  sections.push :resource_details, [T('method_details')]
  sections.push :definition_details, [T('method_details')]
end

def get_items_of_type(cookbook, type)
  items = []
  cookbook.children.each do |child|
    if child.type == type
      items.push(child)
    end 
  end
  return items
end
