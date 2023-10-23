# Speed Lightning Documentation

## Introduction
This gem makes the Speed Lightning service easier to access from within your Ruby project.

It's a "lightly opinionated" gem making a few assumptions about how you will use the API in order to both harden it against failures, and to simplify the operation:
* By default requests are in livemode: false, meaning it's test mode
* A successful payment always returns to a success url within your app, instead of displaying a success message within the Speed interface
* If requests fail, the gem will retry once, before raising an error
* Target currency is hardcoded as Bitcoin Satoshis "SATS"
* Created and modified times are converted to Ruby time objects as created_at and updated_at to follow conventions
* Default metadata includes `client: "ruby"`, so override it with an empty or your own hash if you want to remove this default
* success_message, cashback, statement_descriptor, object, target_currency, payment_id array are only available within raw_attribute

## Table of Contents
- [Initialization](#initialization)
- [Checkout Link](#checkout-link-object)
- [Error Handling](#error-handling)

## Initialization
```
require 'speed_lightning'
client = SpeedLightning::Client.new(secret_key: ENV["SPEED_API_SECRET"])
```
## Checkout Link Object

### Create

Basic usage with only required parameters, the invoice amount and the success return url:
```
client.create_checkout_link(777, "https://yourwebsite.com/thank_you")
```

Advanced usage with all supported parameters:
```
amount = 777
currency = "SATS"
```

The user forwarded to the success url after successful payment (note: `localhost:3000/thank_you` won't validate):
```
success_url = "https://your_website.com/thank_you"
```

Add optional metadata that links the speed payment with your application data:
```
metadata = {
  order_id: 1,
  user_id: 1,
  product_id: "subscription"}
```

Options that need to be filled by the customer before processing the payment. Default is all false:
```
is_phone_enabled = false
is_email_enabled = true
is_billing_address_enabled = false
is_shipping_address_enabled = false
```

For the livemode parameter the default `false` boolean means test payment on testnet, `true` means live payment on livenet:
```
livemode = false
```

Finally, make a request:
```
checkout_link_object = client.create_checkout_link(
  amount: amount,
  success_url: success_url,
  currency: currency,
  metadata: metadata,
  is_phone_enabled: is_phone_enabled,
  is_email_enabled: is_email_enabled,
  is_billing_address_enabled: is_billing_address_enabled,
  is_shipping_address_enabled: is_shipping_address_enabled,
  livemode: livemode)
```

If creation of object is successful, you can get payment data:
* id of the checkout link, needed to retrieve it later: `checkout_link_object.id`
* url of the checkout link, show to customer so they can pay: `checkout_link_object.url`
* status of the payment: `checkout_link_object.status`
* metadata hash of the payment: `checkout_link_object.metadata`
* email collection status: `checkout_link_object.is_email_enabled`
* phone collection status: `checkout_link_object.is_phone_enabled`
* billing address collection status: `checkout_link_object.is_billing_address_enabled`
* shipping address collection status: `checkout_link_object.is_shipping_address_enabled`
* test or live mode: `checkout_link_object.livemode`

To test payments, you can login to speed and pay the invoice with test satoshis: https://www.ln.dev

### Retrieve

Retrieve a checkout link with the checkout link object's id:
```
retrieved_object = client.retrieve_checkout_link(checkout_link_object.id)
```

Same parameters available as described above in the Create section, in addition to a convenience method that returns true is payment is complete:
```
retrieved_object.paid?
```

Get metadata of the payment, for example order_id: `retrieved_object.metadata["order_id"]`

Get raw attributes: `retrieved_object.raw_attributes`

## Error handling
If the request fails, the gem retries once after one second. If it fails again it raises an error.

Example of how to deal with an error in your application:
```
begin
  checkout_link_object = client.create_checkout_link(11, "invalid url...")
rescue SpeedLightning::Error => e
  # Do something when request fails
  puts "Speed API error detected: #{e.message}"
end

```