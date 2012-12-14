def init
  sections.push :definition_list, [:source]
end

def source
  return if object.source.nil?
  erb(:source)
end
