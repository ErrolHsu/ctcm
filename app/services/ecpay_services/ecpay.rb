module EcpayServices
  class Ecpay
    include EcpaySettings

    Hash_key = Settings.ecpay.hash_key
    Hash_iv  = Settings.ecpay.hash_iv

    private

    def generate_check_mac_value(data)
      str = convert_data_to_string(data)
      Digest::SHA256.hexdigest(url_encode(str).downcase).upcase
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
