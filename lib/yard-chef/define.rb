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

class ChefDefineHandler < YARD::Handlers::Ruby::Base
  handles method_call(:define)
  namespace_only

  YARD::Parser::SourceParser.before_parse_file do |p|
    @@parsed_file =  p.file.to_s
  end

  def process
    path_arr = @@parsed_file.to_s.split('/')
    #puts("#{path_arr[0].to_s}::#{path_arr[1].to_s}::#{path_arr[2].to_s}::#{path_arr[3].to_s}")
    ext_obj = YARD::Registry.resolve(:root, "#{path_arr[0].to_s}::#{path_arr[1].to_s}::#{path_arr[2].to_s}::#{path_arr[3].to_s}")
    #puts("Null Object") if ext_obj.nil?
    define_stmt = statement[1].source.to_s.split(",")
    #puts "#{define_stmt.to_s}"
    define_name = define_stmt[0].slice(1..-1)
    #puts "Define Handler is working: #{define_name}"
    define_obj = YARD::CodeObjects::MethodObject.new(ext_obj, define_name)
    #puts("#{define_obj.object_id}: #{define_obj.path}")
    register(define_obj)
    parse_block(statement.last.last)
    #define_obj.dynamic = false
  end
end
