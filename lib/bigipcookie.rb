# frozen_string_literal: true

# Ruby internal
require 'ipaddr'
# Project internal
require 'bigipcookie/version'

# The global BigIP cookie class
class BigIPCookie
  # Load constant
  include Version

  # The class to decode BigIP cookies
  # @example
  #   bip = BigIPCookie::Decode.new(
  #     'CustomeCookieName=vi20010112000000000000000000000030.20480'
  #   )
  #   bip.auto_decode(ipv6compression: 0)
  #   bip.decoded_cookie
  #   bip.pool_name
  #   bip.cookie_type
  class Decode
    # @return [String] the raw cookie (as provided)
    # @example
    #   'BIGipServer~SuperPool=rd3o20010112000000000000000000000030o80'
    attr_reader :raw_cookie

    # @return [String] the pool name
    attr_reader :pool_name

    # @return [String] the decoded cookie value
    # @example
    #   '[2001:112::30%3]:80'
    attr_reader :decoded_cookie

    # @return [String] the type of the cookie
    # @example
    #   'IPv6 pool members in non-default route domains'
    attr_reader :cookie_type

    # A new instance of cookie
    # @param cookie [String] the raw cookie, either key/value or only the value
    def initialize(cookie)
      @raw_cookie = cookie
      @pool_name = nil
      @decoded_cookie = nil
      @cookie_type = nil
    end

    # Decode IP address
    # @!visibility public
    # @param ip [String] the encoded IP address
    # @param opts [Hash] options for the decoding process (only
    #   :ipv6compression should be used, others are for developers)
    # @option opts [Integer] :default default behavior, default value is 1, if
    #   value is set to 0 it disables :ip2hex and :reverse
    # @option opts [Integer] :ipversion 4 for IPv4 and 6 for IPv6, default is 4,
    #   4 set :joinchar to '.' and :scanby to 2, 6 set :joinchar to ':' and
    #   :scanby to 6
    # @option opts [Integer] :ip2hex encode IP address groups into hexadecimal,
    #   default is 1, set to 0 disable
    # @option opts [Integer] :joinchar the character used to join the IP
    #   address groups, default is '.' (IPv4), for example it can be set to
    #   ':' for IPv6
    # @option opts [Integer] :hex2ip decode hexadecimal IP address groups to
    #   decimal, default is 1, set 0 to disable
    # @option opts [Integer] :reverse reverse the IP address groups if set to 1,
    #   default is 1
    # @option opts [Integer] :ipv6compression compress IPv6 address if set to 1,
    #   default is 1
    # @option opts [Integer] :scanby parse the raw cookie value by n to find IP
    #   address groups, default is 2 for IPv4 and 4 for IPv6
    # @return [String] the decoded IP address
    def decode_ip(ip, opts = {})
      opts[:default] ||= 1
      opts[:ipversion] ||= 4
      opts[:ip2hex] ||= 1
      opts[:joinchar] ||= '.'
      opts[:hex2ip] ||= 1
      opts[:reverse] ||= 1
      opts[:ipv6compression] ||= 1

      if opts[:default].zero?
        opts[:ip2hex] = 0
        opts[:reverse] = 0
      end

      if opts[:ipversion] == 4
        opts[:joinchar] = '.'
        opts[:scanby] = 2
      elsif opts[:ipversion] == 6
        opts[:joinchar] = ':'
        opts[:scanby] = 4
      end

      ip = format('%02x', ip) if opts[:ip2hex] == 1 # ip to hex
      ip = ip.scan(/.{#{opts[:scanby]}}/) # split by n
      ip.reverse! if opts[:reverse] == 1 # reverse array
      ip = ip.map { |i| i.to_i(16) } if opts[:hex2ip] == 1 # hex to ip
      ip = ip.join(opts[:joinchar]) # rejoin
      ip = IPAddr.new(ip).to_s if opts[:ipv6compression] == 1 # ipv6 compression
      return ip
    end

    # Decode the port for IP pool members in default route domains
    # @param port [String] the encoded port
    # @return [String] the decoded decimal port
    def decode_port(port)
      port = format('%02x', port) # port to hex
      port = port.scan(/.{2}/) # split by 2
      port.reverse! # reverse array
      port = port.join # rejoin
      port = port.to_i(16) # hex to port
      return port
    end

    # Decode cookie value for IPv4 pool members
    # @param cookie [String] raw cookie value
    # @return [String] the decoded cookie value
    def ipv4_pm(cookie)
      ip, port, _reserved = cookie.split('.')
      ip = decode_ip(ip)
      port = decode_port(port)
      return "#{ip}:#{port}"
    end

    # Decode cookie value for IPv4 pool members in non-default route domains
    # @param cookie [String] raw cookie value
    # @return [String] the decoded cookie value
    def ipv4_pm_ndrd(cookie)
      id, ip, port = cookie.match(
        /rd([0-9]+)o00000000000000000000ffff([0-9a-zA-Z]{8})o([0-9]{1,5})/
      ).captures
      ip = decode_ip(ip, default: 0)
      return "#{ip}%#{id}:#{port}"
    end

    # Decode cookie value for IPv6 pool members
    # @param cookie [String] raw cookie value
    # @param opts [Hahs] see {decode_ip}
    # @return [String] the decoded cookie value
    def ipv6_pm(cookie, opts = {})
      opts[:default] = 0
      opts[:ipversion] = 6
      opts[:hex2ip] = 0
      ip, port = cookie.match(/vi([0-9a-zA-Z]+).([0-9]+)/).captures
      ip = decode_ip(ip, opts)
      port = decode_port(port)
      return "[#{ip}]:#{port}"
    end

    # Decode cookie value for IPv6 pool members in non-default route domains
    # @param cookie [String] raw cookie value
    # @param opts [Hahs] see {decode_ip}
    # @return [String] the decoded cookie value
    def ipv6_pm_ndrd(cookie, opts = {})
      opts[:default] = 0
      opts[:ipversion] = 6
      opts[:hex2ip] = 0
      id, ip, port = cookie.match(
        /rd([0-9]+)o([0-9a-zA-Z]{32})o([0-9]{1,5})/
      ).captures
      ip = decode_ip(ip, opts)
      return "[#{ip}%#{id}]:#{port}"
    end

    # Return that the cookie is encrypted
    # @param cookie [String] raw cookie value
    # @return [String] Encrypted cookie detection message
    def encrypted(cookie)
      return 'Unknown:Encrypted'
    end

    # Automatically detect the BigIP cookie type
    # @param cookie [String] raw cookie value
    # @return [Integer] detected cookie code (mapped with {decode_cookie})
    def detect_cookie_type(cookie)
      ## IPv4 pool members
      return 400 if /[0-9]{10}\.[0-9]{5}\.0000/.match?(cookie)

      ## IPv4 pool members in non-default route domains
      return 401 if /rd([0-9]+)o00000000000000000000ffff([0-9a-zA-Z]{8})o
      ([0-9]{1,5})/x.match?(cookie)

      ## IPv6 pool members
      return 600 if /vi([0-9a-zA-Z]+).([0-9]+)/.match?(cookie)

      ## IPv6 pool members in non-default route domains
      return 601 if /rd([0-9]+)o([0-9a-zA-Z]{32})o([0-9]{1,5})/.match?(cookie)

      ## Encrypted
      return 999 if /!(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?/.match?(cookie)

      raise 'Unrecognized cookie'
    end

    # Decode the cookie value automatically
    # @param cookie [String] raw cookie value
    # @param opts [Hahs] see {decode_ip}
    # @return [String] the decoded cookie value
    def decode_cookie(cookie, opts = {})
      number = detect_cookie_type(cookie)
      if number == 400
        @cookie_type = 'IPv4 pool members'
        ipv4_pm(cookie)
      elsif number == 401
        @cookie_type = 'IPv4 pool members in non-default route domains'
        ipv4_pm_ndrd(cookie)
      elsif number == 600
        @cookie_type = 'IPv6 pool members'
        ipv6_pm(cookie, opts)
      elsif number == 601
        @cookie_type = 'IPv6 pool members in non-default route domains'
        ipv6_pm_ndrd(cookie, opts)
      elsif number == 999
        @cookie_type = 'Encrypted'
        encrypted(cookie)
      else
        raise "Wrong cookie type numer: #{number}"
      end
    end

    # Get pool name for default cookie name, it can't be called if a default
    #   cookie name is used or if no cookie key was provided
    # @return the pool name
    def retrieve_pool_name
      pool_name = /BIGipServer(.+)=.+/.match(@raw_cookie).captures[0]
      return pool_name
    end

    # Automatically decode the raw cookie, detects if there is a cookie key
    #   (custom or default) or only the value
    # @param opts [Hahs] see {decode_ip}
    # @note
    #   .yardopts-dev must be used to get {decode_ip} documentation
    def auto_decode(opts = {})
      if /\=/.match?(@raw_cookie) # if there is a key
        if /^BIGipServer/.match?(@raw_cookie) # if default cookie name
          pool_name = retrieve_pool_name
          cookie_value = /^BIGipServer.+=(.+)/.match(@raw_cookie).captures[0]
          decoded_cookie = decode_cookie(cookie_value, opts)
          @pool_name = pool_name
        else # custom cookie name
          cookie_value = /.+=(.+)/.match(@raw_cookie).captures[0]
          decoded_cookie = decode_cookie(cookie_value, opts)
          @pool_name = 'unknown'
        end
      else # cookie value only
        decoded_cookie = decode_cookie(@raw_cookie, opts)
        @pool_name = 'unknown'
      end
      @decoded_cookie = decoded_cookie
    end

    private :retrieve_pool_name, :decode_cookie, :detect_cookie_type,
            :ipv6_pm_ndrd, :ipv6_pm, :ipv4_pm_ndrd, :ipv4_pm, :decode_port,
            :decode_ip, :encrypted
  end
end
