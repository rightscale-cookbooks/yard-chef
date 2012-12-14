def init
  @attributes = object.children_by_type(:attribute)

  sections.push :attribute_header, [:table]
end
