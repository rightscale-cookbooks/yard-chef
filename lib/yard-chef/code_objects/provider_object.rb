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
    # A ProviderObject represents a lightweight provider in Chef.
    # See http://docs.opscode.com/essentials_cookbook_lwrp.html
    #
    class ProviderObject < ChefObject
      # Creates a new instance of ProviderObject.
      #
      # @param namespace [NamespaceObject] namespace to which the lightweight
      # provider belongs
      # @param name [String] name of the lightweight provider
      #
      # @return [ProviderObject] the newly created ProviderObject
      #
      def initialize(namespace, name)
        super(namespace, name)
      end

      # Constructs class name for the provider.
      #
      # @return [String] the class name for the lightweight provider
      #
      def class_name
        "Chef::Provider::#{convert_underscores_to_snake_case(@name)}"
      end

      def map_resource(file)
        file_handle = File.open(File.expand_path(file), 'r')
        file_handle.readlines.each do |line|
          if line =~ /#\s@resource/
            resource_name = line.split(%r{@resource })[1].strip
            resource_obj = ResourceObject.new(RESOURCE, resource_name)

            resource_obj.providers |= [self]
            break
          end
        end
      end

      # Actions implemented in the provider.
      #
      # @return [Array<ActionObject>] actions in the provider
      #
      def actions
        elements(:action)
      end
    end

    PROVIDER = ProviderObject.register(CHEF, 'providers')
  end
end
