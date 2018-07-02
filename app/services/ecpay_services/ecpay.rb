module EcpayServices
  class Ecpay
    include EcpaySettings

    Hash_key = Settings.ecpay.hash_key
    Hash_iv  = Settings.ecpay.hash_iv

    class << self
      def check(data, mac)
        (generate_check_mac_value(data) == mac) || (generate_check_mac_value(data, 'md5') == mac)
      end

      def generate_check_mac_value(data, encode = 'sha')
        str = convert_data_to_string(data)
        case encode
        when 'sha'
          Digest::SHA256.hexdigest(url_encode(str).downcase).upcase
        when 'md5'
          Digest::MD5.hexdigest(url_encode(str).downcase).upcase
        end
      end

      def url_encode(str)
        CGI::escape(str).gsub("%21","!").gsub("%2A","*").gsub("%28","(").gsub("%29",")")
      end

      def convert_data_to_string(data)
        sort_data = Hash[ data.sort_by { |key,value| key.downcase} ]
        str = sort_data.keys.reduce('') { |result, key| result << "#{key}=#{data[key]}&" }
        str = "HashKey=#{Hash_key}&#{str}HashIV=#{Hash_iv}"
      end
    end

  end
end
