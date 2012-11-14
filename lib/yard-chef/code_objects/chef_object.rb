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
    class ChefObject < YARD::CodeObjects::ClassObject
      attr_accessor :readme_type

      def initialize(namespace, name)
        super(namespace, name)
        @readme_type = :markup
      end

      def parse_readme(file_path)
        path_arr = file_path.to_s.split('/')
        base_path = path_arr.slice(0..path_arr.index('metadata.rb')-2).join('/')

        # Check for README.rdoc file. If it does not exist, then look for README.md
        readme_path = base_path + '/README.rdoc'
        if File.exists?(File.expand_path(readme_path))
          @docstring ||= IO.read(readme_path)
          @readme_type = :markup
        else
          readme_path = base_path + '/README.md'
          if File.exists?(readme_path)
            @docstring ||= IO.read(readme_path)
            @readme_type = :markdown
          end
        end
      end
          
      def children_by_type(type)
        children = []
        unless self.children.empty?
          self.children.each do |child|
            children.push(child) if child.type == type
          end
        end
        children.sort_by {|item| item.name.to_s}
      end
    end

    # Register 'Chef' as the root namespace
    CHEF = ChefObject.new(:root, 'Chef')
    log.info "Creating [Chef] as 'root' namespace"
  end
end
