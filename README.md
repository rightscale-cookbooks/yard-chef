# YARD-Chef

## Description

yard-chef is a [YARD](http://yardoc.org/) plugin for
[Chef](http://www.opscode.com/chef/) that adds support for documenting Chef
recipes, lightweight resources and providers, libraries and definitions.

## Requirements

* Ruby 1.8.7 or higher
* [YARD](http://yardoc.org/)
* [Ripper](https://github.com/lsegal/ripper18) if you are using Ruby 1.8.x

## Installation

It is available from RubyGems:

    gem install yard-chef

If you are using Ruby 1.8.x, you need to install Ripper as well:

    gem install ripper

## Documenting Your Cookbooks

### Cookbook README
The cookbook README file included in your cookbooks will be the landing page for
each cookbook.  Under this verbatim inclusion of your README will be a
```Cookbook Documentation``` section that contains the auto-generated information

### Cookbook Metadata
This plugin grabs most of it's information from the cookbook metadata.rb file.
This includes the cookbook version and description, recipe descriptions,
attribute names, and attribute descriptions.

The rest of the stuff is parsed from cookbook code itself.

### YARD-Chef Tags
We also need a way to link your providers to their resources.  To do so add a
``` @resource <resource_name>``` tag in each of your provider code.  This tag
should be in a comment separated from other comments, for example:

    # This is my super_cool provider
    # and it does something cool.

    # @resouce super_cool

    # Here is the first action
    ...

### Standard YARD Tags and Comments
Your definitions, libraries, resources and providers can benefit from
adding YARD tags and comments for each class and method.  You can learn more about the tags from
yardoc.org and the [list of available tags](http://rubydoc.info/docs/yard/file/docs/Tags.md#List_of_Available_Tags)

Here is an example of adding standard YARD comments to a definition:

    # Does a database backup.
    #
    # @param [String] backup_type If 'primary' will do a primary backup using volumes. If 'secondary' will do a backup S3.
    #
    # @raise [RuntimeError] If database is not 'initialized'
    define :db_do_backup, :backup_type => "primary" do
      ...
    end

Here is an example of adding YARD comments to a light-weight resource:

    # Install packages required for application server setup
    #
    actions :install

      # Set of packages to be installed in addition to the base application
      # packages
      #
      attribute :packages, :kind_of => Array

The first comment will add a description for a resource action. The second
comment adds a description for a resource attribute. You can also use comments
to document your light-weight provider actions.

## Generating Cookbook Docs

### Rake Task
For generating documentation it is recommended to create a rake task:

    require "rubygems"
    require "chef"
    require "yard"

    YARD::Config.load_plugin 'chef'
    YARD::Rake::YardocTask.new do |t|
      t.files = ['<path_to_cookbooks_repo>/**/*.rb']
      #t.options = ['--debug']
    end

Then just run

    rake yard

### Command-line
From the root of your cookbook repository, run the ```yardoc``` command to
generate documentation using the following command

    yardoc '**/*.rb' --plugin chef

## Viewing Cookbook Docs
YARD output will be present in a folder named "doc" which will be located in
the same folder from where the command was run.

It is recommended to view these pages from a running YARD server.  To start a
local YARD server you should be in the same directory that contains your
generated ./doc directory.  Once there run:

    yard server --reload -B localhost -p 8000 --plugin yard-chef

Add a ```-d``` option flag to run the server in daemon mode.  For more
information about YARD server see [http://yardoc.org/](http://rubydoc.info/docs/yard/file/docs/GettingStarted.md#yard_Executable)

## License

Copyright (c) 2012 RightScale, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Maintained by the RightScale ServerTemplate Team
