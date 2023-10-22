require_relative "speed_lightning/version"
require 'uri'
require 'net/http'
require 'base64'
require 'json'

module SpeedLightning
  class Error < StandardError; end
  class Client
    attr_accessor :api_secret
    API_URL = "https://api.tryspeed.com/"

    def initialize(api_secret)
      @api_secret = api_secret
    end
    
    def make_request(endpoint, request_type, body_hash = nil)
      key = "Basic " + Base64.strict_encode64(@api_secret+":") # no password necessary after colon
      url = URI(API_URL + endpoint)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = request_type.new(url)
      request["accept"] = 'application/json'
      request["speed-version"] = '2022-04-15'
      request["authorization"] = key
      if body_hash
        request["content-type"] = 'application/json'
        request.body = body_hash.to_json
      end
      return JSON.parse(http.request(request).read_body)
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
      request_type = Net::HTTP::Post
      return make_request(endpoint, request_type, body_hash)
    end

    def retrieve_speed_checkout_link(id)
      endpoint = "checkout-links/" + id
      request_type = Net::HTTP::Get
      return make_request(endpoint, request_type)
    end

  end
end
