# Luminati
Ruby-wrapper for communicating with the Luminati.io-network.

## How to use the wrapper
```ruby
luminati        =   Luminati::Client.new('username', 'password', zone: 'gen', port: 22225)
connection      =   luminati.get_connection(country: nil, dns_resolution: nil, session: nil)

session_id      =   connection[:session_id]
proxy_user      =   connection[:username]
proxy_password  =   connection[:password]
proxy_ip        =   connection[:ip_address]
proxy_port      =   connection[:port]
```

Use a custom zone, only use american ips and resolve dns remotely (on the client nodes):
```ruby
luminati        =   Luminati::Client.new('username', 'password', zone: 'customzone', port: 22225)
connection      =   luminati.get_connection(country: 'us', dns_resolution: :remote, session: nil)
```

Specify a session to re-use a previously used ip-address:
```ruby
luminati        =   Luminati::Client.new('username', 'password', zone: 'gen', port: 22225)
connection      =   luminati.get_connection(country: 'us', dns_resolution: :remote, session: '4b21543118c63c5a98397c240bee05ae18d0509d')
```

## Test coverage
Currently missing, will be added later.