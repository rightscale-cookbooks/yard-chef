def init
  sections.push :recipe_list, [:source]
end

def source
  return if object.source.nil?
  erb(:source)
end
