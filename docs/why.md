# Why?

There are already tools capable of decoding BipIP cookies **BUT**...

Most of those tools provide only a CLI interface (no library) so it is getting hard when you want to automate things.

Most of those tools only decode *IPv4 pool members*, no *IPv4 pool members in non-default route domains*, *IPv6 pool members* or *IPv6 pool members in non-default route domains*.

Name                                   | IPv4               | IPv4 ndrd          | IPv6               | IPv6 ndrd          | Enc :closed_lock_with_key: | CLI                | Library            | Online             | Notes
---------------------------------------|--------------------|--------------------|--------------------|--------------------|----------------------------|--------------------|--------------------|--------------------|-------------------------------------------
RABID                                  | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark:         | :heavy_check_mark: | :heavy_check_mark: | :x:                |
[psmet/BIGip-cookie-decoder][1]        | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :heavy_check_mark: | :x:                | :x:                |
[f5-cookie-encode-decode][2]           | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :x:                | :x:                | :heavy_check_mark: |
[bigip-cookie-decoder][3]              | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :x:                | :x:                | :x:                | Google Chrome plugin, only on live targets
[big-ip-encoder-decoder][4]            | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :x:                | :x:                | :heavy_check_mark: |
[DarkLighting/bigip-cookie-decoder][5] | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :heavy_check_mark: | :x:                | :x:                |
[vanshit/BigIP-Cookie-Decoder][6]      | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :heavy_check_mark: | :x:                | :x:                |
[evict/BIG-IP-Cookie-decoding][7]      | :x:                | :heavy_check_mark: | :x:                | :x:                | :x:                        | :heavy_check_mark: | :x:                | :x:                |
[MooseDojo/BigCookie][8]               | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :heavy_check_mark: | :x:                | :x:                |
[ezelf/f5_cookieLeaks][9]              | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :heavy_check_mark: | :x:                | :x:                | only on live targets
[drwetter/F5-BIGIP-Decoder][10]        | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark:         | :heavy_check_mark: | :x:                | :x:                |
[f5_bigip_cookie_disclosure][11] (msf) | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :x:                        | :o:                | :o:                | :x:                | only on live targets
[http-bigip-cookie][12] (nse)          | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :heavy_check_mark: | :x:                | :x:                | only on live targets
[Cookie Decrypter][13] (Burp)          | :heavy_check_mark: | :x:                | :x:                | :x:                | :x:                        | :x: | :x:                | :x:                | only on live targets

Legend:

- IPv4: IPv4 pool members
- IPv4 ndrd: IPv4 pool members in non-default route domains
- IPv6: IPv6 pool members
- IPv6 ndrd: IPv6 pool members in non-default route domains
- Enc :closed_lock_with_key:: encrypted cookie detection
- :o:: partially
- msf: metasploit framework
- nse: nmap script engine

[1]:https://github.com/psmet/BIGip-cookie-decoder
[2]:https://www.nooby.fr/pages/f5-cookie-encode-decode.php
[3]:https://chrome.google.com/webstore/detail/bigip-cookie-decoder/fgbahkaekodceioljkpefkclechnccpl
[4]:http://cheungj.github.io/projects/big-ip-encoder-decoder/
[5]:https://github.com/DarkLighting/bigip-cookie-decoder
[6]:https://github.com/vanshit/BigIP-Cookie-Decoder
[7]:https://github.com/evict/BIG-IP-Cookie-decoding
[8]:https://github.com/MooseDojo/BigCookie
[9]:https://github.com/ezelf/f5_cookieLeaks
[10]:https://github.com/drwetter/F5-BIGIP-Decoder
[11]:https://www.rapid7.com/db/modules/auxiliary/gather/f5_bigip_cookie_disclosure
[12]:https://nmap.org/nsedoc/scripts/http-bigip-cookie.html
[13]:https://github.com/SolomonSklash/cookie-decrypter
