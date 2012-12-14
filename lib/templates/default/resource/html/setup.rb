def init
  @resources = object.resources

  sections.push :resource_list, [:actions, T('attribute'), T('provider')]
end
