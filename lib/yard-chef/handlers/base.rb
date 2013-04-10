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

module YARD::Handlers
  module Chef
    # Base handler for chef elements.
    #
    class Base < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef

      # Gets the name of the handled object.
      #
      def name
        statement.parameters.first.jump(:string_content, :ident).source
      end

      # Registers the cookbook in {YARD::Registry} and returns the same.
      #
      # @return [CookbookObject] the CookbookObject
      #
      def cookbook
        cookbook_name = ""
        path_array = statement.file.to_s.split('/')
        if path_array.include?('metadata.rb')
          cookbook_name = path_array[path_array.index('metadata.rb') - 1]
        else
          cookbook_name = path_array[path_array.length - 3]
        end
        ChefObject.register(CHEF, cookbook_name, :cookbook)
      end

      # Registers the lightweight resource and provider in YARD::Registry and
      # returns the same.
      #
      # @return [ResourceObject or ProviderObject] the lightweight resource or
      # provider
      #
      def lwrp
        path_array = statement.file.to_s.split('/')
        if path_array.include?("resources")
          type = RESOURCE
          type_sym = :resource
        elsif path_array.include?("providers")
          type = PROVIDER
          type_sym = :provider
        else
          raise "Invalid LWRP type #{@path_array.join(',')}"
        end
        file_name = path_array.last.to_s.sub('.rb','')

        cookbook_obj = cookbook
        if file_name == "default"
          lwrp_name = cookbook_obj.name
        else
          lwrp_name = "#{cookbook_obj.name}_#{file_name}"
        end
        ChefObject.register(type, lwrp_name, type_sym)
      end
    end
  end
end
