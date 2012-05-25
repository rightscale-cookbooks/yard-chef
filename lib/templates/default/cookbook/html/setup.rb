include T('default/cookbookelement/html')

def init
  sections.push :cookbook_desc
  sections.push :action_summary, [:items]
  sections.push :attribute_summary, [:items]
  sections.push :definition_summary, [:items]
  sections.push :action_details_list, [T('method_details')]
  sections.push :attribute_details_list, [T('method_details')]
  sections.push :definition_details_list, [T('method_details')]
end

def get_items(type)
  return YARD::Registry.all(:definition).uniq.sort_by {|define| define.name.to_s}
end
