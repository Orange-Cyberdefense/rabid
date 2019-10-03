# Usage

## CLI

```
$ rabid --help
RABID (RApid Big IP Decoder)

Usage:
  rabid [options] <raw_cookie>
  rabid -h | --help
  rabid --version

Options:
  --ipv6-long-format  Display IPv6 address in long format
  --no-color          Disable colorized output
  --short             Display in a short format: display only decoded cookies
  --debug             Display arguments
  -h, --help          Show this screen
  --version           Show version

Examples:
  rabid 'BIGipServer<pool_name>=1677787402.36895.0000' --no-color --short
  rabid 'rd5o00000000000000000000ffffc0000201o80'
  rabid 'CustomeCookieName=vi20010112000000000000000000000030.20480' --ipv6-long-format
  rabid 'BIGipServer~SuperPool=rd3o20010112000000000000000000000030o80' --debug
  rabid 'BIGipServerhttp-pool=!LHmYFDA0qZyj4NoylBEaDn0/k2wesiGt0ANZhWaAohjULoWFXRc1b/yfibypy1qfBzD51kqvmwzfcy4='
```

## Library

```ruby
require 'bigipcookie'

# IPv4 pool members, with pool name
bip = BigIPCookie::Decode.new('BIGipServer<pool_name>=1677787402.36895.0000')
# Automatically decode
bip.auto_decode
# Access the decoded value
bip.decoded_cookie
# Access the pool name
bip.pool_name
# Access the cookie type
bip.cookie_type
```

## Console

Launch `irb` with the library loaded.

```
$ rabid_console 
irb(main):001:0> 
```
