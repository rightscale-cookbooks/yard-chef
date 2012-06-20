include T('default/fulldoc/html')

def init
  sections.push :cookbook_title, [:cookbook_desc]
  sections.push :recipes, :object_title, [:recipes_table]
  sections.push :attributes, :object_title, [:attributes_table]
  sections.push :resources, :object_title, [:object_list]
  sections.push :definitions, :object_title, [:definitions_list]
  sections.push :libraries, :object_title, [:library_list]

  @libraries = YARD::Registry.all(:module)
end

def component_name(object)
  case object.class.to_s
    when 'YARD::CodeObjects::Chef::RecipeObject'
      'Recipes'
    when 'YARD::CodeObjects::Chef::AttributeObject'
      'Attributes'
    when 'YARD::CodeObjects::Chef::ResourceObject'
      'Resources'
    when 'YARD::CodeObjects::Chef::DefinitionObject'
      'Definitions'
    when 'String'
      'Libraries'
  end
end

def find_library(library_file)
  libs = []
  @libraries.each do |library|
    if library.file == library_file
      libs.push(library)
    end
  end
  libs
end
