require 'spec_helper'

module Capistrano
  class DummyDSL
    include DSL
  end
end

describe Capistrano::Locally do
  it 'has a version number' do
    expect(Capistrano::Locally::VERSION).not_to be nil
  end

  let(:dsl) { Capistrano::DummyDSL.new }
  let(:servers) do
    [::Capistrano::Configuration::Server.new("server1"),
     ::Capistrano::Configuration::Server.new("server2"),
     ::Capistrano::Configuration::Server.new("localhost"),
     ::Capistrano::Configuration::Server.new("server3"),
     ::Capistrano::Configuration::Server.new("127.0.0.1"),
     ::Capistrano::Configuration::Server.new("server10")]
  end
  let(:locally_servers) do
    servers.reject do |server|
      server.hostname == 'localhost'
    end
  end

  it 'keeps the same method parameters with the original' do
    original = dsl.method(:original_on)
    override = dsl.method(:on)
    expect(override.parameters).to eq original.parameters
  end

  describe '#on' do
    let(:opts) { {} }
    let(:block) { proc { true } }
    it 'calls the original "#on" with arguments excluding "localhost" server' do
      allow(dsl).to receive(:original_on).with(locally_servers, opts, &block)
      dsl.on(servers, opts, &block)
    end
  end

  describe '#with_unbundled_env?' do
    context 'with default configuration' do
      it 'returns truthy' do
        expect(dsl.with_unbundled_env?).to be_truthy
      end
    end
    context 'with the :run_locally_with_unbundled_env is set to false' do
      it 'returns falsy' do
        dsl.set(:run_locally_with_unbundled_env, false)
        expect(dsl.with_unbundled_env?).to be_falsy
        dsl.set(:run_locally_with_unbundled_env, nil)
      end
    end
    context 'with the old key :run_locally_with_clean_env is set to false' do
      around do |example|
        dsl.set(:run_locally_with_clean_env, false)
        example.run
        dsl.set(:run_locally_with_clean_env, nil)
      end
      it 'returns falsy' do
        expect(dsl.with_unbundled_env?).to be_falsy
      end
      it 'shows a Deprecation message' do
        expect { dsl.with_unbundled_env? }.to output(/\[Deprecation Notice\]/).to_stderr
      end
    end
  end
end
