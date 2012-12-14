def init
  @providers = object.providers

  case object.type
  when :resource
    sections.push :providers_list
  when :cookbook
    sections.push :providers_summary, [T('action')]
  end
end
