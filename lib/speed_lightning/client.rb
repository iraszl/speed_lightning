require 'httparty'
require_relative 'error'
require_relative 'checkout_link_methods'

module SpeedLightning
  class Client
    include HTTParty
    include CheckoutLinkMethods
    attr_accessor :api_secret
    API_URL = "https://api.tryspeed.com/"

    def initialize(secret_key:)
      @secret_key = secret_key
    end
    
    def make_request(endpoint, request_type, body_hash = nil)
      headers = {
        "Accept" => "application/json",
        "Speed-Version" => "2022-04-15",
        "Authorization" => "Basic " + Base64.strict_encode64(@secret_key + ":")
      }
      headers["Content-Type"] = "application/json" if body_hash
      options = { headers: headers }
      options[:body] = body_hash.to_json if body_hash
      full_url = API_URL + endpoint
      response =
        case request_type
        when :get
          self.class.get(full_url, options)
        when :post
          self.class.post(full_url, options)
        end
      
        parsed_response = JSON.parse(response.body)
      
      if parsed_response['errors'] && !parsed_response['errors'].empty?
        error_messages = parsed_response['errors'].map { |error| error['message'] }.compact
        concatenated_error_message = error_messages.join(', ')
        raise SpeedLightning::Error, concatenated_error_message
      end         
      
      parsed_response
    end

  end
end