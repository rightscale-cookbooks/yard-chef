def init
  sections.push :resource_list, [:actions, :attributes, :providers]
end

def get_cookbook(file)
  path_arr = file.to_s.split('/')
  cookbook_name = path_arr[path_arr.size - 3]
  cookbook = YARD::CodeObjects::Chef::ChefObject.register(
    YARD::CodeObjects::Chef::CHEF,
    cookbook_name,
    :cookbook
  )
  cookbook
end
