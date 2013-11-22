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

module YARD::CodeObjects::Chef
  module Helper
    def is_metadata?(file)
      file.split('/').include?('metadata.rb') ? true : false
    end

    def lwrp_name(file_path)
      name = get_object_name(file_path)
      name == 'default' ? get_cookbook_name(file_path) : name
    end

    def convert_underscores_to_snake_case(string)
      output = ''
      string.to_s.split('_').each { |str| output << str.to_s.capitalize }
      output
    end

    def get_cookbook_name(file_path)
      cookbook_name = ''
      path_array = File.expand_path(file_path).to_s.split('/')
      if is_metadata?(file_path)
        cookbook_name = path_array[path_array.index('metadata.rb') - 1]
      else
        cookbook_name = path_array[path_array.length - 3]
      end
      cookbook_name
    end

    def get_object_name(file_path)
      path_array = File.expand_path(file_path).to_s.split('/')
      path_array.last.to_s.sub('.rb','')
    end

    def register_resource(name, file)
      cookbook = CookbookObject.register(COOKBOOK, get_cookbook_name(file))
      resource_obj = ResourceObject.register(RESOURCE, name)
      cookbook.resources |= [resource_obj]
      resource_obj
    end
  end
end
