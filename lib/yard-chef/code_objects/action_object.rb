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
    # An ActionObject represents an action in a lightweight provider.
    # See http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+%28LWRP%29#LightweightResourcesandProviders%28LWRP%29-Keyword%3Aaction
    #
    class ActionObject < ChefObject
      register_element :action

      # Creates a new instance of the ActionObject
      #
      # @param namespace [NamespaceObject] namespace to which the action belongs
      # @param name [String] name of the action
      #
      # @return [ActionObject] the newly created ActionObject
      def initialize(namespace, name)
        super(namespace, name)
      end
    end
  end
end
