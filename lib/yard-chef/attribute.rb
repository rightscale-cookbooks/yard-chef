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

class ChefAttributeHandler < YARD::Handlers::Ruby::Base
  handles method_call(:attribute)
  namespace_only

  #YARD::Parser::SourceParser.before_parse_file do |p|
    #@@parsed_file =  p.file.to_s
  #end

  def process
    #path_arr = @@parsed_file.to_s.split('/')
    #ext_obj = YARD::Registry.resolve(namespace, "#{path_arr[0].to_s}::#{path_arr[1].to_s}::#{path_arr[2].to_s}::#{path_arr[3].to_s}")
    #puts "#{path_arr.to_s}"
    attrib_stmt = statement[1].source.to_s.split(",")
    attrib_name = attrib_stmt[0]
    #puts "Attribute Handler is working: #{attrib_name}"
    #puts "#{ext_obj}"
    attrib_obj = YARD::CodeObjects::MethodObject.new(namespace, attrib_name)
    register(attrib_obj)
    #parse_block(statement.last.last, :owner => attrib_obj)  #getting some errors
    attrib_obj.dynamic = false
  end
end
