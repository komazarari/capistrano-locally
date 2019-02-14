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

  context '#on' do
    let(:opts) { {} }
    let(:block) { proc { true } }
    it 'calls the original "#on" with arguments excluding "localhost" server' do
      allow(dsl).to receive(:original_on).with(locally_servers, opts, &block)
      dsl.on(servers, opts, &block)
    end
  end
end
