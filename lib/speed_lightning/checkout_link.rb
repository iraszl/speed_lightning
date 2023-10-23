class CheckoutLink
  attr_accessor :id, :amount, :currency, :url, :success_url, :status, :metadata, :is_email_enabled, :is_phone_enabled, :is_billing_address_enabled, :is_shipping_address_enabled, :livemode, :created_at, :updated_at, :raw_attributes

  def initialize(attributes = {})
    @id = attributes['id']
    @amount = attributes['amount']
    @currency = attributes['currency']
    @url = attributes['url']
    @success_url = attributes['success_url']
    @status = attributes['status']
    @metadata = attributes['metadata']
    @is_email_enabled = attributes.dig('customer_collections_status', 'is_email_enabled')
    @is_phone_enabled = attributes.dig('customer_collections_status', 'is_phone_enabled')
    @is_billing_address_enabled = attributes.dig('customer_collections_status', 'is_billing_address_enabled')
    @is_shipping_address_enabled = attributes.dig('customer_collections_status', 'is_shipping_address_enabled')
    @livemode = attributes['livemode']
    # Convert the Unix timestamp in milliseconds to Ruby's Time object
    @created_at = Time.at(attributes['created'] / 1000.0)
    @updated_at = Time.at(attributes['modified'] / 1000.0)
    @raw_attributes = attributes
  end

  def to_hash
    {
      id: @id,
      amount: @amount,
      currency: @currency,
      success_url: @success_url,
      metadata: @metadata,
      customer_collections_status: {
        is_email_enabled: @is_email_enabled,
        is_phone_enabled: @is_phone_enabled,
        is_billing_address_enabled: @is_billing_address_enabled,
        is_shipping_address_enabled: @is_shipping_address_enabled
      },
      livemode: @livemode
    }
  end

  def paid?
    @status == "paid"
  end
  
end