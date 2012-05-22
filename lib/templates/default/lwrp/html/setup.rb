def init
  super
  @cookbooks = Registry.all(:cookbookname).sort_by{|cookbook| cookbook.name.to_s}
  sections.push :lwrp
end

def items_of_type(cookbook, type)
  meth_arr = Array.new
  cookbook.meths.each do |method|
    meth_arr.push(method) if method.type == type
  end
  return meth_arr
end
