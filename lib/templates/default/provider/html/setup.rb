def init
  sections.push :title, [:provider_list, [:action_list, [:source]]]
end

def source
  return if owner != object.namespace
  return if Tags::OverloadTag === object
  return if object.source.nil?
  erb(:source)
end
