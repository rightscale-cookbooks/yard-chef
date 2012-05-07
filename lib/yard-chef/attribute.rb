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
  module AbstractAttributeHandler
    @@abstract_attribute_handler_process = Proc.new do
      path_arr = @@parsed_file.to_s.split('/')
      ext_obj = YARD::Registry.resolve(:root, "#{path_arr[0].to_s}::#{path_arr[1].to_s}::#{path_arr[2].to_s}::#{path_arr[3].to_s}", true)
      read, write = true, false
      params = statement.parameters(false).dup
      params.pop

      name = statement.parameters.first.jump(:tstring_content, :ident).source
      attr_new = MethodObject.new(ext_obj, name, scope) do |o|
        src = "attribute :#{name},"
        full_src = statement.first_line
        o.source ||= full_src
        o.signature ||= src
        full_docs=nil
        param_line = nil
        cut_line = nil

        if (statement.comments.to_s.include? "param" || "attribute")
            o.docstring = statement.comments.to_s
        else
          st_comments = statement.comments.to_s

          if (statement.comments.to_s.empty?)
            full_docs = "Sets the attribute #{name}"
          else
            #full_docs = "Sets the attribute #{name}"
            full_docs = statement.comments.to_s
          end

          cut_line = statement.first_line.delete "\"" "=>"
          param_line = cut_line.split(', :')
          param_line.each do |e|

           if (!e.to_s.include? "attribute")
           #  if (e.to_s.include? "kind_of")
            #   e_splited = e.to_s.split(' ')
            #   full_docs << " \n@return [#{e_splited[1].to_s}] "
            # else
               full_docs << " \n@param #{e.to_s} "
           #  end
           else
             c_temp=1
           end

          end
          o.docstring = full_docs
        end
        o.visibility = visibility
      end
      attr_new.add_file("#{parser.file.to_s}", nil, false)
      push_state(:scope => :class) {
        YARD::Registry.register(attr_new)
        #attr_new.object_id
       # puts attr_new.path
      }
    end

    YARD::Parser::SourceParser.before_parse_file do |p|
      @@parsed_file =  p.file.to_s
    end
  end

  class AttributeHandler < YARD::Handlers::Ruby::AttributeHandler
    include AbstractAttributeHandler

    handles method_call(:attribute)
    namespace_only
    process &@@abstract_attribute_handler_process
  end

  module Legacy
    class AttributeHandler < YARD::Handlers::Ruby::Legacy::AttributeHandler
      include AbstractAttributeHandler

      handles /\Aattribute[\s\(].*/m
      namespace_only
      process &@@abstract_attribute_handler_process
    end
  end
end
