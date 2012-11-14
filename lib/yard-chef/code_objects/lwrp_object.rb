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
    class LWRPObject < ChefObject
      def self.name(cookbook, lwrp_name)
        if lwrp_name == 'default'
          @name = self.construct_lwrp_name(cookbook)
        else
          @name = self.construct_lwrp_name(cookbook, lwrp_name)
        end
      end

      def self.construct_lwrp_name(cookbook_name, lwrp_name = '')
        self.lwrp_format(cookbook_name) << self.lwrp_format(lwrp_name)
      end

      def self.lwrp_format(name)
        formatted_name = ''
        if name =~ /_/
          name.split('_').each do |str|
            formatted_name << str.to_s.capitalize
          end
        else
          formatted_name = name.capitalize
        end
        formatted_name
      end
    end
  end
end
