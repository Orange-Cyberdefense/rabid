# Quick start

## Quick install

```
$ gem install rabid
```

## Default usage: CLI

```
$ rabid 'BIGipServer<pool_name>=1677787402.36895.0000'
Pool name: <pool_name>
Cookie type: IPv4 pool members
Raw cookie: BIGipServer<pool_name>=1677787402.36895.0000
Decoded cookie: 10.1.1.100:8080
```

## Default usage: library

```ruby
require 'bigipcookie'

# IPv4 pool members, with pool name
bip = BigIPCookie::Decode.new('BIGipServer<pool_name>=1677787402.36895.0000')
# Automatically decode
bip.auto_decode
# Print result
puts "Cookie: #{bip.decoded_cookie}"
```