def init
  sections.push :cookbook_title, [:cookbook_desc]
  sections.push :recipes, [:recipes_table]
  sections.push :attributes, [:attributes_table]
  sections.push :resources, [:resource_list]
  sections.push :definitions, [:definitions_list]
  sections.push :libraries, [:library_list]

  @libraries = YARD::Registry.all(:module)
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
