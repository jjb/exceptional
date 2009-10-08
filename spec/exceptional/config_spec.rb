require File.dirname(__FILE__) + '/../spec_helper'

describe Exceptional::Config, 'defaults' do
  before :each do
    Exceptional::Config.reset
  end
  it "have sensible defaults" do
    Exceptional::Config.ssl_enabled?.should == false
    Exceptional::Config.remote_host.should == 'api.getexceptional.com'
    Exceptional::Config.remote_port.should == 80
    Exceptional::Config.application_root.should == File.expand_path('./../../..')
  end
  it "have correct defaults when ssl_enabled" do
    Exceptional::Config.ssl_enabled = true
    Exceptional::Config.remote_host.should == 'getexceptional.appspot.com'
    Exceptional::Config.remote_port.should == 443
  end
  it "be enabled based on environment by default" do
    %w(development test).each do |env|
      Exceptional::Config.load('',env)
      Exceptional::Config.enabled?.should == false
    end
    %w(production staging).each do |env|
      Exceptional::Config.load('',env)
      Exceptional::Config.enabled?.should == true
    end
  end
  it "will allow a new simpler format for exception.yml" do
    Exceptional::Config.load('','production','spec/fixtures/exceptional.yml')
    Exceptional::Config.api_key.should == 'abc123'
    Exceptional::Config.ssl_enabled?.should == true
    Exceptional::Config.remote_host.should == 'example.com'
    Exceptional::Config.remote_port.should == 123
    Exceptional::Config.enabled?.should == true
  end

  it "will allow olded format for exception.yml" do
    Exceptional::Config.load('','production','spec/fixtures/exceptional_old.yml')
    Exceptional::Config.api_key.should == 'abc123'
    Exceptional::Config.ssl_enabled?.should == true
    Exceptional::Config.enabled?.should == true
  end
end