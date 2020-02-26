# frozen_string_literal: true

require 'minitest/autorun'
require 'bigipcookie'

class BigIPCookieTest < Minitest::Test
  # IPv4 pool members, with pool name
  def test_bigipcookie_decode_ipv4_pm
    # Size (ip/port) 10 + 5
    bip = BigIPCookie::Decode.new('BIGipServer<pool_name>=1677787402.36895.0000')
    bip.auto_decode
    # Decoded cookie
    assert_equal('10.1.1.100:8080', bip.decoded_cookie)
    # Pool name
    assert_equal('<pool_name>', bip.pool_name)
    # Cookie type
    assert_equal('IPv4 pool members', bip.cookie_type)
    # Test cookie with different encoded lenght
    # Size (ip/port) 9 + 5
    bip = BigIPCookie::Decode.new('135851530.20480.0000')
    bip.auto_decode
    assert_equal('10.238.24.8:80', bip.decoded_cookie)
    # Size (ip/port) 8 + 0
    bip = BigIPCookie::Decode.new('34467338.0.0000')
    bip.auto_decode
    assert_equal('10.238.13.2:0', bip.decoded_cookie)
  end

  # IPv4 pool members in non-default route domains, only cookie value
  def test_bigipcookie_decode_ipv4_pm_ndrd
    bip = BigIPCookie::Decode.new('rd5o00000000000000000000ffffc0000201o80')
    bip.auto_decode
    # Decoded cookie
    assert_equal('192.0.2.1%5:80', bip.decoded_cookie)
    # Pool name
    assert_equal('unknown', bip.pool_name)
    # Cookie type
    assert_equal('IPv4 pool members in non-default route domains', bip.cookie_type)
  end

  # IPv6 pool members, custom cookie name, long ipv6 format
  def test_bigipcookie_decode_ipv6_pm
    bip = BigIPCookie::Decode.new('CustomeCookieName=vi20010112000000000000000000000030.20480')
    bip.auto_decode(ipv6compression: 0)
    # Decoded cookie
    assert_equal('[2001:0112:0000:0000:0000:0000:0000:0030]:80', bip.decoded_cookie)
    # Pool name
    assert_equal('unknown', bip.pool_name)
    # Cookie type
    assert_equal('IPv6 pool members', bip.cookie_type)
  end

  # IPv6 pool members in non-default route domains
  def test_bigipcookie_decode_ipv6_pm_ndrd
    bip = BigIPCookie::Decode.new('BIGipServer~SuperPool=rd3o20010112000000000000000000000030o80')
    bip.auto_decode
    # Decoded cookie
    assert_equal('[2001:112::30%3]:80', bip.decoded_cookie)
    # Pool name
    assert_equal('~SuperPool', bip.pool_name)
    # Cookie type
    assert_equal('IPv6 pool members in non-default route domains', bip.cookie_type)
  end

  def test_encrypted
    bip = BigIPCookie::Decode.new('BIGipServerhttp-pool=!LHmYFDA0qZyj4NoylBEaDn0/k2wesiGt0ANZhWaAohjULoWFXRc1b/yfibypy1qfBzD51kqvmwzfcy4=')
    bip.auto_decode
    # Decoded cookie
    assert_equal('Unknown:Encrypted', bip.decoded_cookie)
    # Pool name
    assert_equal('http-pool', bip.pool_name)
    # Cookie type
    assert_equal('Encrypted', bip.cookie_type)
  end

  def test_encrypted_2
    bip = BigIPCookie::Decode.new('BIGipServerhttp-pool=!VGVzdCBzdHJpbmcgMiBlcXVhbCBzaWducw==')
    bip.auto_decode
    # Decoded cookie
    assert_equal('Unknown:Encrypted', bip.decoded_cookie)
    # Pool name
    assert_equal('http-pool', bip.pool_name)
    # Cookie type
    assert_equal('Encrypted', bip.cookie_type)
  end
end
