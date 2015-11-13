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
    # An AttributeObject represents a cookbook or a resource attribute.
    # See http://wiki.opscode.com/display/chef/Attributes
    #
    class AttributeObject < ChefObject
      register_element :attribute

      # Creates a new instance of the AttributeObject.
      #
      # @param namespace [NamespaceObject] namespace to which the attribute
      # belongs
      # @param name [String] name of the attribute
      #
      # @return [AttributeObject] the newly created AttribteObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @kind_of = ''
        @default = ''
      end

      # Returns JSON representation of attribute name
      #
      # @return [String] JSON string
      def to_json
        json_string = "    {\n"
        # default[:cluster][:config][:openstack][:volume_default_type]
        if name =~ /(.+?)(\[.+\])/
          # "default"
          attribute_type = $1
          # [:cluster][:config][:openstack][:volume_default_type]
          json_string += "      \"#{attribute_type}_attributes\": {\n      ...\n"
          deepness = 2
          attrs_tree = $2.split('[')
          while (attr = attrs_tree.shift)do
            next if attr.empty?
            attr = attr.gsub(/[:"'](.+?)["']?\]/,'\\1')
            # Indent
            json_string += (' ' * (deepness + 2) * 2)
            # Attr name
            json_string += "\"#{attr}\""
            if attrs_tree.empty?
              json_string += ": \"VALUE\"\n"
            else
              # New branch
              json_string += ": {\n" if attrs_tree.size > 0
              deepness += 1
            end
          end

          # Closing brackets
          deepness -= 1
          deepness.times do |d|
            # Indent
            json_string += (' ' * (deepness - d + 2) * 2)
            # Attr name
            json_string += "}\n"
          end
        end
        json_string + "      ...\n    }\n"
      end
    end
  end
end
