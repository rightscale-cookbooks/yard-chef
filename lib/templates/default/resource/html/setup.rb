include T('default/fulldoc/html')

def init
  sections.push :title
  sections.push :resource_name, [:action_table, :attribute_table, :providers]
end
