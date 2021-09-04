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

        if (defined? Bundler) && with_unbundled_env?
          Bundler.with_unbundled_env do
            klass.new(localhost, &block).run
          end
        else
          klass.new(localhost, &block).run
        end
      end

      original_on(remotehosts, options, &block)
    end

    def with_unbundled_env?
      [deprecated_with_unbundled_env?, fetch(:run_locally_with_unbundled_env, true)].find do |val|
        !val.nil?
      end
    end

    private

    def dry_run?
      fetch(:sshkit_backend) == SSHKit::Backend::Printer
    end

    def deprecated_with_unbundled_env?
      fetch(:run_locally_with_clean_env).tap do |val|
        $stderr.puts(<<~MESSAGE) unless val.nil?
          [Deprecation Notice] `set :run_locally_with_clean_env` has been deprecated \
          in favor of `set :run_locally_with_unbundled_env`.
        MESSAGE
      end
    end
  end
end
