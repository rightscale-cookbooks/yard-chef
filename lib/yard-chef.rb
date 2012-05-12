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

YARD::Parser::SourceParser.before_parse_file do |parser|
  path_var = parser.file.to_s.split('/')
  #puts("#{path_var}\n0=#{path_var[0]}::1=#{path_var[1]}::2=#{path_var[2]}::3=#{path_var[3]}")
  #Root cookbook object
  id0 = YARD::CodeObjects::ClassObject.new(:root, path_var[0].to_s) do |o|
    #Description for coobooks
    if (File.exists?(File.join(File.dirname(__FILE__)+'/', 'LICENSE.rdoc')))
      o.docstring = IO.read(File.join(File.dirname(__FILE__)+'/', 'LICENSE.rdoc'))
    else
      o.docstring = "#{path_var[0]} folder"
    end
  end
  id0.add_file('/'+path_var[0].to_s, nil, false)
  YARD::Registry.register(id0)

  #Cookooks registration
  id1 = YARD::CodeObjects::ClassObject.new(id0, path_var[1].to_s) do |o|
    if (File.exists?(File.dirname(__FILE__)+'/'+path_var[0].to_s+'/'+path_var[1].to_s+'/'+'README.rdoc'))
      o.docstring = IO.read(File.join(File.dirname(__FILE__)+'/'+path_var[0].to_s+'/'+path_var[1].to_s+'/', 'README.rdoc'))
    else
      o.docstring = "#{path_var[1]} folder"
    end
  end
  id1.add_file('/'+path_var[0].to_s+'/'+path_var[1].to_s, nil, false)
  id1.superclass = id0
  YARD::Registry.register(id1)

  #Cookbooks elements registration
  id2 = YARD::CodeObjects::ClassObject.new(id1, path_var[2].to_s) do |o|
    o.docstring = "#{path_var[2]} folder"
  end
  id2.add_file('/'+path_var[0].to_s+'/'+path_var[1].to_s+'/'+path_var[2].to_s, nil, false)
  id2.superclass = id1
  YARD::Registry.register(id2)
  #puts("File: #{parser.file.to_s}")


  #This block was written by Nick
  #===============================
  desc =  IO.readlines(parser.file)
  str=""
  for i in 0..6
    str_t = desc[i].delete  '#'
    if i == 1
      str_t.insert(0, ' =')
    end
    str << str_t
  end
  id3 = YARD::CodeObjects::ClassObject.new(id2, path_var[3].to_s) do |o|
    o.docstring = str
  end
  id3.add_file("#{parser.file.to_s}", nil, false)
   #=======================================

  #This written by me
  #====================
  #id3 = YARD::CodeObjects::ClassObject.new(id2, path_var[3].to_s) do |o|
   # o.docstring = "#{path_var[3]} folder"
  #end
  #id3.add_file('/'+path_var[0].to_s+'/'+path_var[1].to_s+'/'+path_var[2].to_s+'/'+path_var[3].to_s, nil, false)
  #=======================

  id3.superclass = id2
  YARD::Registry.register(id3)
end
puts ("hi")
#if RUBY19
#require 'yard-chef/class'
  require 'yard-chef/action'
  #require '~/yard-chef/lib/yard-chef/class'
  #require 'yard-chef/attribute'
  require 'yard-chef/define'
#end
#end
