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
    # A CookbookObject represents a Chef cookbook. See http://wiki.opscode.com/display/chef/Cookbooks for more information about cookbook.
    class CookbookObject < ChefObject
      register_element :cookbook

      # Short description for the cookbook.
      # @param [String] short_desc text to be assigned as short description.
      # @return [String] short description for the cookbook.
      attr_accessor :short_desc

      # Version of cookbook.
      # @param [String] version text to be set as cookbook version.
      # @return [String] cookbook version.
      attr_accessor :version

      # Cookbook lightweight resources.
      # @return [Array<ResourceObject>] lightweight resources.
      attr_reader :resources

      # Cookbook lightweight providers.
      # @return [Array<ProviderObject>] lightweight providers.
      attr_reader :providers

      # Cookbook libraries.
      # @return [Array<NamespaceObject>] cookbook libraries.
      attr_reader :libraries

      # Cookbook definitions.
      # @return [Array<DefinitionObject>] cookbook definitions.
      attr_reader :definitions

      # Type of README file (:rdoc, :markdown, etc.).
      # @return [Symbol] README type.
      attr_reader :readme_type

      # Creates a new CookbookObject instance.
      # @param [NamespaceObject] namespace namespace to which the cookbook belongs to.
      # @param [String] name name of the cookbook.
      # @return [CookbookObject] instance of CookbookObject.
      def initialize(namespace, name)
        super(namespace, name)
        @resources = []
        @providers = []
        @libraries = []
        @readme_type = :markdown
      end

      # Parses README file in the cookbooks/<name> directory.
      # @param [String] path to README file.
      def parse_readme(file_path)
        path_arr = file_path.to_s.split('/')

        base_path = path_arr.slice(0..path_arr.index('metadata.rb')-1).join('/')

        # Look for README.rdoc. If it doesn't exist then look for README.md.
        readme_path = base_path + '/README.rdoc'
        if File.exists?(readme_path)
          @docstring = YARD::DocstringParser.new.parse(IO.read(readme_path)).to_docstring
          @readme_type = :rdoc
        else
          readme_path = base_path + '/README.md'
          @docstring = YARD::DocstringParser.new.parse(IO.read(readme_path)).to_docstring if File.exists?(readme_path)
        end
      end
    end
  end
end

