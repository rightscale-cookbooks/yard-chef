# yard-chef

## Description

yard-chef is a [YARD](http://yardoc.org/) plugin for
[Chef](http://www.opscode.com/chef/) that adds support for documenting Chef
recipes, lightweight resources and providers, libraries and definitions.

## Requirements

* Ruby 1.8.7 or higher
* [YARD](http://yardoc.org/)
* [Ripper](https://github.com/lsegal/ripper18) if you are using Ruby 1.8.x
* [Redcarpet](https://github.com/vmg/redcarpet) for parsing files with
  markdown formatting.

## Installation

It is available from RubyGems:

```
gem install yard-chef
```

If you are using Ruby 1.8.x, you need to install Ripper as well:

```
gem install ripper
```

## Usage

It can be used with yard as a plugin:

```
yardoc --plugin chef cookbooks/**/*.rb
```

It can be used in a Rakefile:

```ruby
require 'yard'

YARD::Config.load_plugins 'chef'
YARD::Rake::YardocTask.new do |t|
  t.files = ['<path_to_cookbooks_repo>/**/*.rb']
end
```

## YARD output

Run yard with the chef plugin as follows

```
yardoc --plugin chef cookbooks/**/*.rb
```
or

```
rake yard
```

YARD output will be present in a folder named "doc" which will be present in
the same folder from where the command was run.

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
