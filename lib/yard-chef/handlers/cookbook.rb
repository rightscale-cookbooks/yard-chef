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
    # Handles specific cookbook information like README, description and version.
    #
    class CookbookHandler < Base
      handles method_call(:description)
      handles method_call(:version)

      def process
        return unless statement.file.to_s =~ /metadata.rb/

        # Register the cookbook
        cookbook_obj = cookbook
        cookbook_obj.add_file(statement.file)
        case statement.first.source
        when 'description'
          cookbook_obj.short_desc = name
        when 'version'
          cookbook_obj.version = name
        end

        # Get the README file for the cookbook
        base_dir = File.dirname(statement.file)
        if cookbook_obj.docstring == ''
          cookbook_obj.docstring, cookbook_obj.docstring_type = docstring(base_dir)
        end

        # Get the top-level README for the cookbook repository if it exists
        if CHEF.docstring == ''
          readme_dir = File.expand_path('../..', base_dir)
          CHEF.docstring, CHEF.docstring_type = docstring(readme_dir)
        end
      end

      # Get the name of the method being handled.
      #
      # @return [String] the method name
      #
      def name
        string = ''
        value = statement.parameters.first
        if value.is_a?(YARD::Parser::Ruby::MethodCallNode)
          # The content is code, so evaluate it in the correct directory
          # This handles ruby code like File.read in metadata.rb
          current_directory = Dir.getwd
          Dir.chdir(File.expand_path(File.dirname(statement.file)))
          string << eval(value.source)
          Dir.chdir current_directory
        else
          # YARD builds an abstract syntax tree (AST) which we need to traverse
          # to obtain the complete docstring
          value.traverse do |child|
            string << child.jump(:string_content).source if child.type == :string_content
          end
        end
        string
      end

      # Generates docstring from the README file.
      #
      # @return [YARD::Docstring] the docstring
      #
      def docstring(base_dir)
        type = ''
        string = ''
        readme_path = base_dir + '/README.md'
        if File.exist?(readme_path)
          type = :markdown
          string = IO.read(readme_path)
        else
          readme_path = base_dir + '/README.rdoc'
          if File.exist?(readme_path)
            type = :rdoc
            string = IO.read(readme_path)
          end
        end
        [YARD::DocstringParser.new.parse(string).to_docstring, type]
      end
    end
  end
end
