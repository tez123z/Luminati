require 'faraday'
require 'faraday_middleware'

module Luminati
  class Client
    attr_accessor :username, :password, :zone, :port, :urls, :regexes
    
    def initialize(username, password, zone: :gen, port: 22225)
      self.username   =   username
      self.password   =   password
      
      self.zone       =   zone
      self.port       =   port
      
      self.urls       =   {
        master_proxy: "http://client.luminati.io/api/get_super_proxy"
      }
      
      self.regexes    =   {
        failed_auth:    /failed\sauth/i,
        invalid_params: /invalid\sparams/i
      }
    end
    
    def get_connection(country: nil, dns_resolution: :remote, session: nil)
      ip_address              =   self.fetch_master_proxy
      user_auth               =   self.generate_user_auth(country: country, dns_resolution: dns_resolution, session: session)
      
      return {ip_address: ip_address, port: self.port, password: self.password}.merge(user_auth)
    end
    
    def generate_user_auth(country: nil, dns_resolution: :remote, session: nil)
      country                 =   (country && country.to_s.present?) ? "-country-#{country}" : ""
      zoned                   =   "-zone-#{self.zone}"
      dns_resolution          =   "-dns-#{dns_resolution}"
      session_id              =   (session && session.to_s.present?) ? session : generate_session_id
      session                 =   "-session-#{session_id}"
      
      user                    =   "#{self.username}#{zoned}#{country}#{dns_resolution}#{session}"
      
      return {username: user, session_id: session_id}
    end
    
    def fetch_master_proxy(country: nil)
      arguments       =   {raw:  1}
      arguments.merge!(country: country) if country
      proxy           =   get_response(self.urls[:master_proxy], arguments)
    end
    
    def fetch_master_proxies(limit: 10)
      arguments       =   {format: :json, limit: limit}
      proxies         =   get_response(self.urls[:master_proxy], arguments)
    end
    
    def ping_master_proxy(address, port: self.port)
      response        =   get_response("http://#{address}:#{port}/ping")
    end
    
    def ping_master_proxies(proxies, port: self.port)
      data            =   {}
    
      proxies.each do |proxy|
        data[proxy]   =   self.ping_master_proxy(proxy, port)
      end if proxies && proxies.any?
      
      return data
    end
    
    private
    def generate_session_id
      Digest::SHA1.hexdigest([Time.now, rand].join)
    end
    
    def format_username(username)
      username        =   (username =~ /-zone-([a-z0-9]*)/i).nil? ? "#{username}-zone-#{self.zone}" : username
    end
    
    def get_response(url, arguments = {}, options = {})
      arguments.merge!(user: format_username(self.username), key: self.password)
      
      connection      =   build_connection(options)
      response        =   connection.get(url, arguments)
      response        =   (response && response.body) ? response.body : nil
      
      check_response_for_errors(response)
      
      return response
    end
    
    def check_response_for_errors(response)
      if (response && response.is_a?(String) && !response.empty?)
        raise Luminati::FailedAuthError, "Failed to authenticate your account with Luminati.io. Please check your credentials or the contract for your account." if response =~ self.regexes[:failed_auth]
        raise Luminati::InvalidParamsError, "Failed to perform your requested action since invalid parameters were supplied." if response =~ self.regexes[:invalid_params]
      end
    end
    
    def build_connection(options = {})
      options.merge!(:ssl => {:verify => false})
      
      connection      =   Faraday.new(options) do |builder|
        builder.request   :retry, max: 3, exceptions: ['StandardError', 'Timeout::Error']
        builder.response  :json,  content_type: /\bjson$/
        builder.adapter   Faraday.default_adapter
      end
      
      return connection
    end
    
  end
end