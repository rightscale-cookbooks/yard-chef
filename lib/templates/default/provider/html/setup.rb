def init
  sections.push :action_list, [:source]
end

def source
  return if object.source.nil?
  erb(:source)
end
