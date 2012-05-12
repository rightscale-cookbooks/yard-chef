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

class ChefActionHandler < YARD::Handlers::Ruby::Base
  handles method_call(:action)
  namespace_only

  YARD::Parser::SourceParser.before_parse_file do |p|
    @@parsed_file =  p.file.to_s
  end

  def process
    path_arr = @@parsed_file.to_s.split('/')
    puts("File: #{@@parsed_file.to_s}")
    #puts "#{path_arr.to_s}"
    ext_obj = YARD::Registry.resolve(:root, "#{path_arr[0].to_s}::#{path_arr[1].to_s}::#{path_arr[2].to_s}::#{path_arr[3].to_s}")
    #puts "#{DocString.docstring.to_s}" if !namespace.nil?
    #action_name = statement.parameters.first.jump(:tstring_content, :ident).source
    action_name = statement[1].source.slice(1..-1)
    #puts "Action Handler is working: #{action_name}"
    action_obj = YARD::CodeObjects::MethodObject.new(ext_obj, action_name)
    puts("#{action_obj.object_id}: #{action_obj.path}")
    register(action_obj)
    parse_block(statement.last.last)
    #action_obj.dynamic = false
  end
end
