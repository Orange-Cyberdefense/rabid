# Changelog

## [0.0.5]

- Fix a case when the encoded IP address in IPv4 pool members was decoded to an odd hexadecimal number resulting in a malformated IP address
- Fix the regexp for IPv4 pool members cookie were the encoded IP and port length was fix instead of variable
- Add more test for those cases

## [0.0.4]

- Fix regex in `auto_decode` and `retrieve_pool_name` for base64 encoded cookie (encrypted) - lazy quantifier instead of greedy one to match the first `=` sign

## [0.0.3]

- Update `commonmarker` dependency

## [0.0.2]

- Encrypted cookie detection

## [0.0.1]

- Initial version
