include T('default/fulldoc/html')

def init
  @objects = @@cookbooks
  sections.push :title, :definition_list, [:definition_name, T('docstring'), :source]
end

def source
  return if owner != object.namespace
  return if Tags::OverloadTag === object
  return if object.source.nil?
  erb(:source)
end
