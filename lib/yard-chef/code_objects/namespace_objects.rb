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
    
    class CookbookElementObject < ClassObject ; end
    class ProviderObject < CookbookElementObject ; end

    class ResourceObject < CookbookElementObject
      attr_accessor :actions
      def initialize(namespace, name)
        super(namespace, name)
        @actions = []
      end
    end

    class CookbookObject < ClassObject
      def initialize(namespace, name)
        super(namespace, name)
      end

      def get_lwrp_name(filename)
        if filename == 'default.rb'
          return @name
        else
          return "#{@name}_#{filename.split('.')[0]}"
        end    
      end 
    end

    YARD::Parser::SourceParser.before_parse_list do |files, globals|
      @@RS_NAMESPACE = ClassObject.new(:root, "RightScale")
      #TODO: Should we had code this path?
      @@RS_NAMESPACE.docstring = IO.read('rightscale_cookbooks/README.rdoc')

      @@LWRP = CookbookElementObject.new(@@RS_NAMESPACE, "LWRP")
    end

    # Register Providers and Resources along with Cookbooks before processing file
    YARD::Parser::SourceParser.before_parse_file do |parser|
      path_arr = parser.file.to_s.split("/")
      
      # Check if cookbook has already been created
      ns_obj = YARD::Registry.resolve(:root, "#{@@RS_NAMESPACE}::#{path_arr[2].to_s}")
      if ns_obj == nil 
        cookbook = CookbookObject.new(@@RS_NAMESPACE, path_arr[2].to_s)
        cookbook.docstring = IO.read("#{path_arr[0].to_s}/#{path_arr[1].to_s}/README.rdoc")
        cookbook.add_file(parser.file)
        log.info "Creating [Cookbook] #{cookbook.name} => #{cookbook.namespace}"
      else
        cookbook = ns_obj
        log.info "Using existing cookbook #{cookbook.name} => #{cookbook.namespace}"
      end

      case path_arr[3].to_s
      when 'providers'
        @@provider = ProviderObject.new(cookbook, cookbook.get_lwrp_name(path_arr[4].to_s))
        log.info "Creating [Provider] #{@@provider.name} => #{@@provider.namespace}"
      when 'resources'
        @@resource = ResourceObject.new(cookbook, cookbook.get_lwrp_name(path_arr[4].to_s))
        log.info "Creating [Resource] #{@@resource.name} => #{@@resource.namespace}"
      end
    end
  end
end
