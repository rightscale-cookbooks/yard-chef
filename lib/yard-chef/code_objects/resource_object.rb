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

module YARD::CodeObjects
  module Chef
    # A <ResourceObject> represents a lightweight resource in chef. See http://docs.opscode.com/essentials_cookbook_lwrp.html
    class ResourceObject < ChefObject
      register_element :resource

      # Creates a new instance of ResourceObject.
      # @param [NamespaceObject] namespace namespace to which the Lightweight Resource belongs.
      # @param [String] name name of the Lightweight Resource.
      def initialize(namespace, name)
        super(namespace, name)
        @actions = []
        @providers = []
      end

      # Constructs long name (class path) for the lightweight resource.
      # @return [String] generated class name for the lightweight resource.
      def long_name
        name = ''
        if @name.to_s =~ /_/
          @name.to_s.split('_').each do |str|
            name << str.to_s.capitalize
          end
        else
          name = @name.to_s.capitalize
        end
        "#{@namespace}::#{name}"
      end
    end

    RESOURCE = ChefObject.register(CHEF, 'Resource', :resource)
  end
end
