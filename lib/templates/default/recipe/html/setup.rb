include T('default/fulldoc/html')

def init
  @objects = @@cookbooks
  sections.push :title, :recipe_list, [:recipe_name, T('docstring'), :source]
end

def source
  return if owner != object.namespace
  return if Tags::OverloadTag === object
  return if object.source.nil?
  erb(:source)
end

def get_recipe_name(recipe)
  cookbook_name = recipe.parent.name.to_s
  cookbook_name == recipe.name.to_s ? cookbook_name : cookbook_name << '::' << recipe.name.to_s
end
