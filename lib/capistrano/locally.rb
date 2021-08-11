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

        if (defined? Bundler) && fetch_setting_related_bundler_with_unbundled_env
          Bundler.with_unbundled_env do
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

    def fetch_setting_related_bundler_with_unbundled_env
      value = fetch(:run_locally_with_unbundled_env)
      value = fetch_run_locally_with_clean_env if use.nil?
      value = true if use.nil?

      value
    end

    def fetch_run_locally_with_clean_env
      value = fetch(:run_locally_with_clean_env)

      unless value.nil?
        $stderr.puts(<<-MESSAGE)
[Deprecation Notice] `set :run_locally_with_clean_env` has been deprecated in favor of `set :run_locally_with_unbundled_env`.
MESSAGE
      end

      value
    end
  end
end
