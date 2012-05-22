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
    class CookbookNameObject < YARD::CodeObjects::ClassObject
      attr_accessor :actions, :attributes, :definitions
      def initialize(namespace, name)
        #@name = CookbookNameObject.fixName(name)
        #@namespace = CookbookNameObject.findNamespace(namespace)
        #super(@namespace, @name)
        super(namespace, name)
        @actions = @attributes = @definitions = []
      end

      def self.findNamespace(name)
        case name
        when "providers"
          return PROVIDER_NAMESPACE
        when "resources"
          return RESOURCE_NAMESPACE
        when "definitions"
          return DEFINITION_NAMESPACE
        else
          return nil
        end
      end

      # TODO: Check if I can generalize the method below
      # Assumption: path_arr consists of 
      # 0 - rightscale_cookbooks
      # 1 - cookbooks
      # 2 - name of the cookbook
      # 3 - cookbook element
      # 4 - file name
      def createCookbookName(path_arr)
        if path[4].to_s == "default.rb"
          return path_arr[2].to_s
        else
          # split file name from extension '.rb'
          name = path_arr[4].to_s.split(".")
          return "#{path_arr[2].to_s}_#{name[0]}"
        end
      end
       
      def self.fixName(name)
        if name =~ /_/
          name_arr = name.split('_')
          first_part = name_arr[0].to_s
          second_part = name_arr[1].to_s
          first_part[0] = first_part[0].capitalize
          second_part[0] = second_part[0].capitalize
          name = first_part+'_'+second_part
        else
          name[0] = name[0].capitalize
        end
        return name
      end
    end

    def read_comments(file)
      desc =  IO.readlines(file)
      str = ""
      for i in 0..6
        str_t = desc[i].delete '#'
        if i == 1
          str_t.insert(0, ' =')
        end
        str << str_t
      end
    end

    YARD::Parser::SourceParser.before_parse_file do |parser|
      path_arr = parser.file.to_s.split("/")
      #name = CookbookNameObject.new(path_arr[3].to_s, path_arr[2].to_s)
      name = CookbookNameObject.new(CHEF_NAMESPACE, path_arr[2].to_s)
      log.info "Creating [Cookbook Name] #{name.name} (#{name.object_id}) => #{name.namespace}"
    end
  end
end
