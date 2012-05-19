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

module YARD::Handlers
  module Chef
    class ClassHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      @@number = 0
      @@cookbook = nil
      @@element = nil
      def initialize
        @name = nil
      end
      
      def process
      end

      # Registers 'cookbook', 'cookbook elements' and 'cookbook names' as classes
      # Returns namespace
      def register_cookbooks(path_arr, statement)
        # Check if this cookbooks are already registered
        # TODO: Bad Implementation of check_registry. Need to unify check_* methods
        @name = check_registry(path_arr)
        if !@name.to_s.empty?
          #log.info "Using existing namespace #{@name.to_s}"
          return @name
        end 
        
        #Register cookbook
        if @@number == 0
        @@cookbook = Cookbook.new(:root, "Chef") do |cookbook|
          cookbook.docstring = statement.comments
          cookbook.superclass = :root
        end
        log.info "Creating '#{@@cookbook.name}' class #{@@cookbook.object_id}: #{@@cookbook.path}"
        @@number = 1
        end
        #Register cookbook_elements
        if @@number == 1
        @@element = CookbookElement.new(@@cookbook, path_arr[3].to_s) do |element|
          #element.path = path_arr[1].to_s+'/'+path_arr[2].to_s+'/'+path_arr[3].to_s
          element.superclass = @@cookbook
          element.docstring = statement.comments
        end
        log.info "Creating '#{@@element.name}' class #{@@element.object_id}: #{@@element.path}"
        @@number = 2
        end

        #Register cookbook_name
        @name = CookbookName.new(@@element, path_arr[2].to_s) do |name|
            name.superclass = @@element
            name.docstring = statement.comments
            # TODO: Check if I can do the below function in a cleaner way
            # Hint: Use the custom code_objects classes
            #name.path = path_arr[1].to_s+'/'+path_arr[2].to_s
        end
        log.info "Creating '#{@name.name}' class #{@name.object_id}: #{@name.path}"

        return @name.namespace
      end

      def check_registry(path_arr)
        element = path_arr[3].to_s[0..-2]
        element[0] = element[0].capitalize

        name = path_arr[2].to_s
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

        return YARD::Registry.resolve(:root, "Chef::#{element}::#{name}")
      end
    end
  end
end
