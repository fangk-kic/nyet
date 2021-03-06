require "spec_helper"

describe "Managing MySQL", :service => true do
  let(:app_name) { "mysql" }
  let(:namespace) { "mysql" }
  let(:plan_name) { "100mb" }
  let(:service_name) { "mysql" }

  it "allows users to create, bind, read, write, unbind, and delete the Mysql service" do
    create_and_use_managed_service do |client|
      client.insert_value('key', 'value').should be_a Net::HTTPSuccess
      client.get_value('key').should == 'value'
    end
  end

  it "allows us to bind and unbind to an existing instance after a restart" do
    use_managed_service_instance(ENV['NYET_EXISTING_INSTANCE_ID']) do |client|
      client.insert_value('key', 'value').should be_a Net::HTTPSuccess
      client.get_value('key').should == 'value'
    end
  end
end
