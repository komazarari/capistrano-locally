require "capistrano/locally/version"
require "capistrano/dsl"

module Capistrano
  module Locally
  end
end


module Capistrano
  module DSL
    alias original_on on

    def on(hosts, options={}, &block)
      return unless hosts
      localhosts, remotehosts = Array(hosts).partition { |h| h.hostname.to_s == 'localhost' }
      localhost = Configuration.env.filter(localhosts).first

      unless localhost.nil?
        klass = if dry_run?
                  SSHKit::Backend::Printer
                else
                  SSHKit::Backend::Local
                end
        if defined? Bundler
          Bundler.with_clean_env do
            klass.new(localhost, &block).run
          end
        else
          klass.new(localhost, &block).run
        end
      end

      original_on(remotehosts, options, &block)
    end

    private
    def dry_run?
      fetch(:sshkit_backend) == SSHKit::Backend::Printer
    end
  end
end
