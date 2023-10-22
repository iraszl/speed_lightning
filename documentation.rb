# Initialize Speed Lightning client
require 'speed_lightning'
client = SpeedLightning::Client.new(ENV["SPEED_API_SECRET"])

# Checkout Link

# Basic usage with only required parameters: invoice amount, success return url:
create_cl_response = client.create_speed_checkout_link(777, "https://yourwebsite.com/thank_you")

# Advanced usage with all optional parameters:
amount = 777
success_url = "https://yourwebsite.com/thank_you"
currency = "SATS"
metadata = {
  order_id: 1, 
  user_id: 1,
  product_id: 1c
}
customer_collections_status = {
  is_phone_enabled: false,
  is_email_enabled: true,
  is_billing_address_enabled: false,
  is_shipping_address_enabled: false
}
create_cl_response = client.create_speed_checkout_link(amount, success_url, currency, metadata, customer_collections_status)
puts create_cl_response["id"] # id of the checkout link, needed to retrieve it later
puts create_cl_response["url"] # url of the checkout link, show to customer so they can pay

# Retrieve a checkout link by id:
id = create_cl_response["id"]
retrieve_response = client.retrieve_speed_checkout_link(id)
puts retrieve_response["status"] # status of the payment