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
    class ResourceObject < ChefObject
      def initialize(namespace, name)
        super(namespace, name)
        @actions = []
        @providers = []
      end

      def self.register(resource_name)
        resource = YARD::Registry.resolve(:root, "#{RESOURCE}::#{resource_name}")
        if resource.nil?
          resource_obj = self.new(RESOURCE, resource_name)
          log.info "Created [RESOURCE] #{resource_obj.name} => #{resource_obj.namespace}"
        else
          resource_obj = resource
        end
        resource_obj
      end

      def map_providers(providers_list)
        providers_list.each do |provider|
          if provider.resources.size > 0
            provider.resources.each do |res|
              if self.path.to_s == res.strip
                self.providers.push(provider)
                break
              end
            end
          end
        end
      end
    end
    RESOURCE = ResourceObject.new(CHEF, 'resource')
    log.info "Created [Resource] namespace => #{RESOURCE.namespace}"
  end
end
