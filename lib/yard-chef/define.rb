require 'yard'

module YARD::Handlers::Chef
  module AbstractDefineHandler
    def process
      path_arr = @@parsed_file.to_s.split('/')
      ext_obj = YARD::Registry.resolve(:root, "#{path_arr[0].to_s}::#{path_arr[1].to_s}::#{path_arr[2].to_s}::#{path_arr[3].to_s}", true)

      name = statement.parameters.first.jump(:tstring_content, :ident).source
      object = YARD::CodeObjects::MethodObject.new(ext_obj, name)
      register(object)
      object.object_id
      parse_block(statement.last.last)
      object.dynamic = true
    end

    YARD::Parser::SourceParser.before_parse_file do |p|
      @@parsed_file =  p.file.to_s
    end
  end

  class DefineHandler < YARD::Handlers::Ruby::Base
    include AbstractDefineHandler

    handles method_call(:define)
    namespace_only
  end

  module Legacy
    class DefineHandler < YARD::Handlers::Ruby::Legacy::Base
      include AbstractDefineHandler

      handles /\Adefine[\s\(].*/m
      namespace_only
    end
  end
end
