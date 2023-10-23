require_relative "speed_lightning/version"
require 'httparty'
require 'base64'
require 'json'

module SpeedLightning
  class Error < StandardError; end
  class Client
    include HTTParty
    attr_accessor :api_secret
    API_URL = "https://api.tryspeed.com/"

    def initialize(api_secret)
      @api_secret = api_secret
    end
    
    def make_request(endpoint, request_type, body_hash = nil)
      headers = {
        "Accept" => "application/json",
        "Speed-Version" => "2022-04-15",
        "Authorization" => "Basic " + Base64.strict_encode64(@api_secret + ":")
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
      JSON.parse(response.body)
    end

    def create_speed_checkout_link(
      amount,
      success_url,
      currency = "SATS",
      metadata = { client: "ruby" },
      customer_collections_status = {
        is_phone_enabled: false,
        is_email_enabled: false,
        is_billing_address_enabled: false,
        is_shipping_address_enabled: false
      }
    )
      body_hash = {
        amount: amount,
        success_url: success_url,
        currency: currency,
        metadata: metadata,
        customer_collections_status: customer_collections_status
      }
      endpoint = "checkout-links"
      return make_request(endpoint, :post, body_hash)
    end

    def retrieve_speed_checkout_link(id)
      endpoint = "checkout-links/" + id
      return make_request(endpoint, :get)
    end

  end
end
