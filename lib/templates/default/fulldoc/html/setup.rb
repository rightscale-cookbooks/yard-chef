def init
  super
  serialize(YARD::CodeObjects::Chef::CHEF_NAMESPACE)

  YARD::CodeObjects::Chef::CHEF_NAMESPACE.children.find_all.each do |child|
    serialize(child)
    child.children.find_all.each do |child|
      serialize(child.namespace)
    end
  end
end
