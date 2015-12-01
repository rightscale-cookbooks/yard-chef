# YARD-Chef

  * [YARD-Chef](#yard-chef)
    * [Description](#description)
    * [Requirements](#requirements)
    * [Installation](#installation)
    * [Documenting Your Cookbooks](#documenting-your-cookbooks)
      * [README.md](#readmemd)
      * [Resources](#resources)
      * [Providers](#providers)
      * [Attributes](#attributes)
      * [Recipes](#recipes)
      * [Cookbooks (metadata.rb)](#cookbooks-metadatarb)
        * [Cookbook Dependencies](#cookbook-dependencies)
      * [Libraries](#libraries)
      * [Standard YARD Tags and Comments](#standard-yard-tags-and-comments)
    * [Generating Cookbook Docs](#generating-cookbook-docs)
      * [Rake Task](#rake-task)
      * [Command-line](#command-line)
    * [Viewing Cookbook Docs](#viewing-cookbook-docs)
    * [License](#license)

## Description

yard-chef is a [YARD](http://yardoc.org/) plugin for
[Chef](http://www.opscode.com/chef/) that adds support for documenting Chef
recipes, lightweight resources and providers, libraries and definitions.

## Requirements

* Ruby 1.9 or higher
* [YARD](http://yardoc.org/)

## Installation

It is available from RubyGems:

    gem install yard-chef

## Documenting Your Cookbooks

### README.md

The cookbook `README.md` file included in your cookbooks will be the landing page for
each cookbook.  Under this verbatim inclusion of your `README.md` will be a
```Cookbook Documentation``` section that contains the auto-generated information

### Resources

Resource example:

```ruby
# Volume ID
attribute :device, :kind_of => String
# Filesystem type
attribute :fstype, :kind_of => String, :default => 'ext4'
# Volume mount point
attribute :mount, :kind_of => String
...    
# Disable volume in fstab and do umount
actions :disable
# Format volume if not formatted, mount and add entry to fstab
actions :enable
# Do volume format via mkfs
# Will do nothing if any filesystem already exists on volume
actions :mkfs
```

Comment above the `attribute` will be used as description for resource attributes in resource attributes table in documentation.
Keyword `:kind_of` will be used as for type column and `:default` as default value column.

To have better documentation of our resources, please describe each action separately with keyword `actions` and comment above it.
Actions will be also described in providers, so use this description as short summary for action.

If you want to see list of providers for your resource, please use YARD tag `@resource` in your providers (check **Providers** section)

### Providers

In providers will be described only actions, there you can place more detailed description of action and example of usage.

Example:

```ruby
# @resource sys_volume

#
# Create filesystem on specified device
#
# @example Create EXT4 partition on `/dev/vdc`
#    sys_volume 'HOME' do
#      device '/dev/vdc'
#      device 'ext4'
#      action :enable
#    end
#
# @note *WARNING!* Please use this action carefully
action :mkfs do
...
end
```

If you add tag `@resource` in the beginning of your provider you will see this provider in providers list of resource.

Tag `@example` used for code examples, text after tag will be used as title for code example. Please not that code example should have two spaces indent in each line.

Tag `@note` used for warning or additional info highlight.

### Attributes

To document your attributes exists two ways, first describe it in cookbooks `metadata.rb` as described in [OpsCode documentation](https://docs.chef.io/config_rb_metadata.html)

```ruby
attribute "repo/default/revision",
  :display_name => "Repository Branch/Tag/Commit",
  :description =>
    "The specific branch, tag, or commit (SHA) of the specified" +
    " Git/Subversion repository that the application code will" +
    " be retrieved from. For Git repositories, use 'master'" +
    " to retrieve the master branch from the repository." +
    " For SVN repositories, use 'HEAD' to retrieve the latest changes" +
    " from the repository. Example: mybranch",
```

Attribute description will be received from `:description` section.
But this method requires too many efforts to keep it up-to-date, always actual attributes will be placed in `cookbook/attributes/*.rb` file, so better to comment attributes there:

```ruby
#
# Default Yum repos
#
# String "http://192.168.1.100/mrepo/..." should be last element in `:baseurl` array, to be first
# RPMs mirror for `yum`
default[:sys][:yum_repos] = {
    'epel_local' => {
        :description => 'Extra Packages for Enterprise Linux [LOCAL]',
        :baseurl  => %w(
          http://mirror.euserv.net/linux/fedora-epel/$releasever/$basearch/
          http://dl.fedoraproject.org/pub/epel/$releasever/$basearch/
          http://192.168.1.100/mrepo/EPEL$releasever-$basearch/RPMS.os/
        ),
        :gpgcheck => false,
        :enabled => true
    },
    ...
}
```

Attribute `default[:sys][:yum_repos]` will be added in **Cookbook attributes** table, comment above as description and `'epel_local' => ...` will be added as default value for this attribute.

### Recipes

Recipes can be documented also in two ways, with keyword `recipe` in `metadata.rb` file of cookbook ([OpsCode documentation](https://docs.chef.io/config_rb_metadata.html)).

Example:

```ruby
recipe 'cluster::converge',
       'Create instance and run converge'
```

First argument will be recipe name, second recipe short description, this data will be used in **Recipes summary** section of cookbook documentation.

To add long description of recipe, please add in the begining of your recipe comment section with leading string `*Description:*`, like in example below:

```ruby
#
# Cookbook Name:: cluster
# Recipe:: create
#
# Copyright 2015, YOUR_COPYRIGHT
#
# All rights reserved - Do Not Redistribute
#

# *Description*
#
# to create and provision one node set NODENAME ENV variable like: `NODENAME="..."`
#
# usage:
#
#     NODENAME="risk01" chef-client -E "env" -c ~/.chef/knife.rb --runlist "recipe[cluster::converge]"
#
# ...

# cluster name
cluster_name = ENV['OPSCODE_ORGNAME']
```

Comment section beggining from `*Description*` till `...` will be used as detailed description of recipe in 
**Recipe details** section of cookbook documentation.
Please note, that first line of your code in recipe should have it own comment, in example above `cluster_name = ENV['OPSCODE_ORGNAME']` 
have its own comment.

You can also use tags `@note` and `@example` like for providers.

### Cookbooks (metadata.rb)

Short cookbook description and version will be received from keyworks `description` and `version` in `metadata.rb` file:

```ruby
description      'Installs/Configures Elastic Search cluster'
version          '3.2.0'
```

This fields will be used in cookbooks list on the index page of your cookbooks documentation.

#### Cookbook Dependencies

Please describe each dependency of your cookbook with `depends` keyword in `metadata.rb` and place proper comment, why 
this dependency needed.

```ruby
# Subversion provider for `repo` resource
depends "svn"
# Git provider for `repo` resource
depends "git"
```

This information will be used in **Cookbook dependencies** section of documentation for your cookbook.

### Libraries

Comment your libraries as regular Ruby code, for more information please read [list of available tags](http://rubydoc.info/docs/yard/file/docs/Tags.md#List_of_Available_Tags)

```ruby
# Search of image by name or by id
# @param name_or_id [String] image name or ID, search by name works as regexp
#   image.name =~ /#{name_or_id}/
# @return [Fog::Image] image object
def find_image(name_or_id)
   ...
end
```

### Standard YARD Tags and Comments

Your definitions, libraries, resources and providers can benefit from
adding YARD tags and comments for each class and method.  You can learn more about the tags from
yardoc.org and the [list of available tags](http://rubydoc.info/docs/yard/file/docs/Tags.md#List_of_Available_Tags)

Here is an example of adding standard YARD comments to a definition:

```ruby
# Does a database backup.
#
# @param [String] backup_type If 'primary' will do a primary backup using volumes. If 'secondary' will do a backup S3.
#
# @raise [RuntimeError] If database is not 'initialized'
# @return [Boolean] status if backup done or not
define :db_do_backup, :backup_type => "primary" do
  ...
end
```

## Generating Cookbook Docs

### Rake Task
For generating documentation it is recommended to create a rake task:

```ruby
require "rubygems"
require "chef"
require "yard"

YARD::Config.load_plugin 'chef'
YARD::Rake::YardocTask.new do |t|
  t.files = ['<path_to_cookbooks_repo>/**/*.rb']
  #t.options = ['--debug']
end
```

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

Copyright (c) 2015 Aleksey Hariton (aleksey.hariton@gmail.com)

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
