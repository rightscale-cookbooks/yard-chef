# Copyright (c) 2012 RightScale, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
