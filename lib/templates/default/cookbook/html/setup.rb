def init
  sections.push :cookbook_title, [:cookbook_desc, 
                :recipes, [:recipes_table],
                :attributes, [:attributes_table],
                :resources, [:resource_list],
                :definitions, [:definitions_list],
                :libraries, [:library_list]]
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
