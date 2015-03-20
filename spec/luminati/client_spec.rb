require File.expand_path('../../spec_helper', __FILE__)

describe "Luminati::Client"  do
  
  context "initialization" do    
    it "should set the correct instance variables for a new client with default initialization settings" do
      username  =   'user'
      password  =   'password'
      client    =   Luminati::Client.new(username, password)
      
      expect(client.username).to be == username
      expect(client.password).to be == password
      expect(client.zone).to be == :gen
      expect(client.port).to be == 22225
    end
    
    it "should set the correct instance variables for a new client with custom initialization settings" do
      username  =   'user'
      password  =   'password'
      client    =   Luminati::Client.new(username, password, zone: :custom, port: 12345)
      
      expect(client.username).to be == username
      expect(client.password).to be == password
      expect(client.zone).to be == :custom
      expect(client.port).to be == 12345
    end
  end
  
  # TODO: Add more specs that actually test the real integration
  
end

