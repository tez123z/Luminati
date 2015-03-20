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
  
  context "master proxy" do
    it "should be able to fetch a master proxy with correct credentials" do
      client    =   Luminati::Client.new(CREDENTIALS['username'], CREDENTIALS['password'])
      proxy     =   client.fetch_master_proxy
      
      expect(proxy).not_to be_nil
      expect(proxy).not_to be_empty
      expect(proxy).to match(Resolv::IPv4::Regex)
    end
    
    it "should not be able to fetch a master proxy with incorrect credentials" do
      client    =   Luminati::Client.new('user', 'password')
      expect{client.fetch_master_proxy}.to raise_error(Luminati::InvalidParamsError)
    end
  end
  
  context "connection" do
    it "should successfully be able to retrieve a valid connection with correct credentials" do
      client      =   Luminati::Client.new(CREDENTIALS['username'], CREDENTIALS['password'])
      connection  =   client.get_connection
      
      expect(connection).not_to be_nil
      expect(connection).not_to be_empty
      expect(connection[:ip_address]).to match(Resolv::IPv4::Regex)
      expect(connection[:port]).to be == 22225
    end
    
    it "should not be able to retrieve a valid connection with incorrect credentials" do
      client    =   Luminati::Client.new('user', 'password')
      expect{client.get_connection}.to raise_error(Luminati::InvalidParamsError)
    end
  end
  
end