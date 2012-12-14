def init
  case object.type
  when :cookbook
    @providers = object.providers
    sections.push :action_list, [:source]
  when :provider
    @actions = object.children_by_type(:action)
    sections.push :action_summary
  end
end

def source
  return if object.source.nil?
  erb(:source)
end
