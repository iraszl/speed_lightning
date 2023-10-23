require_relative 'checkout_link'
require_relative 'retryable'

module SpeedLightning
  module CheckoutLinkMethods
    include Retryable 

    def create_checkout_link(
        amount:,
        success_url:,
        currency: "SATS",
        metadata: { client: "ruby" },
        is_phone_enabled: false,
        is_email_enabled: false,
        is_billing_address_enabled: false,
        is_shipping_address_enabled: false,
        livemode: false
      )
      with_retry do
        body_hash = {
          amount: amount,
          success_url: success_url,
          currency: currency,
          metadata: metadata,
          customer_collections_status: {
              is_email_enabled: is_email_enabled,
              is_phone_enabled: is_phone_enabled,
              is_billing_address_enabled: is_billing_address_enabled,
              is_shipping_address_enabled: is_shipping_address_enabled
            },
          livemode: livemode
        }
        endpoint = "checkout-links"
        response = make_request(endpoint, :post, body_hash)
        CheckoutLink.new(response)
      end
    end

    def retrieve_checkout_link(id)
      with_retry do
        endpoint = "checkout-links/" + id
        response = make_request(endpoint, :get)
        CheckoutLink.new(response)
      end
    end

  end
end