include T('default/fulldoc/html')

def init
  sections.push :cookbook_title, [:cookbook_desc]
  sections.push :recipes_title, [:recipes_table]
  sections.push :attributes_title, [:attributes_table]
  sections.push :resources_title, [:resource_list]
  #sections.push :definitions_title, [:definition_list]
  #sections.push :libraries_title, [:library_list]
end
