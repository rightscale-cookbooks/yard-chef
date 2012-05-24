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

require "yard"

module YARD::CodeObjects
  module Chef
    class ClassObject < YARD::CodeObjects::ClassObject
      def initialize(namespace, name)
        super(namespace, name)
      end
    end
    
    CHEF = ClassObject.new(:root, "Chef")
    LWRP = ClassObject.new(CHEF, "LWRP")
    #class CookbookElementObject < ClassObject ; end

    class ProviderObject < ClassObject ; end

    class ResourceObject < ClassObject
      attr_accessor :actions

      def initialize(namespace, name)
        super(namespace, name)
        @actions = []
      end
    end

    class CookbookObject < ClassObject
      def read_cookbook_desc(file)
        desc =  IO.readlines(file)
        str = ""
        for i in 0..6
          str_t = desc[i].delete('#')
          str_t.insert(0, '= ') if i == 1
          str << str_t
        end 
        return str 
      end

      def get_lwrp_name(filename)
        if filename == 'default.rb'
          return @name
        else
          return "#{@name}_#{filename.split('.')[0]}"
        end    
      end 
    end

    # Register Providers and Resources along with Cookbooks before processing file
    YARD::Parser::SourceParser.before_parse_file do |parser|
      path_arr = parser.file.to_s.split("/")

      cookbook = CookbookObject.new(CHEF, path_arr[2].to_s)
      cookbook.docstring = cookbook.read_cookbook_desc(parser.file)
      cookbook.add_file(parser.file)
      log.info "Creating [Cookbook] #{cookbook.name} => #{cookbook.namespace}"

      case path_arr[3].to_s
      when 'providers'
        provider = ProviderObject.new(cookbook, cookbook.get_lwrp_name(path_arr[4].to_s))
        log.info "Creating [Provider] #{provider.name} => #{provider.namespace}"
      when 'resources'
        resource = ResourceObject.new(cookbook, cookbook.get_lwrp_name(path_arr[4].to_s))
        log.info "Creating [Cookbook] #{resource.name} => #{resource.namespace}"
      end
    end
  end
end
