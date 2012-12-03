include T('default/chef/html')
include T('default/module')

def init
  sections.push :cookbook_title, [:docstring,
                :generated_docs, [:recipes, T('resource'), :providers,
                :attributes, :definitions, :libraries,
                :element_details, [T('recipe'), T('provider'), T('definition')]]]
  @libraries = YARD::Registry.all(:module)
end

def find_library(library_file)
  libs = []
  @libraries.each do |library|
    libs.push(library) if library.file == library_file
  end
  libs
end
