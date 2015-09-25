require "capistrano/locally/version"
require "capistrano/dsl"

module Capistrano
  module Locally
  end
end


module Capistrano
  module DSL
    alias original_on on

    def on(_hosts, options={}, &block)
      localhosts, hosts = _hosts.partition { |h| h.hostname == 'localhost' }
      localhost = Configuration.env.filter(localhosts).first

      run_locally(&block) unless localhost.nil?

      original_on(hosts, options={}, &block)
    end
  end
end
