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

### Available Parameters

* id: speed payment id
* amount: payment amount in satoshis 
* currency: "SATS" by default
* url: payment url to be presented to users
* success_url: url the user is forwarded to after successful payment
* status: payment status
* metadata: metadata to link speed payment with ruby application data
* is_email_enabled: true if user needs to provide email to pay
* is_phone_enabled: true if user needs to provide phone to pay
* is_billing_address_enabled: true if user needs to provide billing address to pay
* is_shipping_address_enabled: true if user needs to provide shipping address to pay
* livemode: default is false for test mode, true is live
* created_at: ruby time object
* updated_at: ruby time object
* raw_attributes: the raw data returned by the Speed API

### Convenience Methods

* paid? : returns true if payment has been completed

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
* metadata hash of the payment: `checkout_link_object.metadata`
* email collection status: `checkout_link_object.is_email_enabled`
* test or live mode: `checkout_link_object.livemode`

To test payments, you can login to speed and pay the invoice with test satoshis: https://www.ln.dev

### Retrieve

Retrieve a checkout link with the checkout link object's id:
```
retrieved_object = client.retrieve_checkout_link(checkout_link_object.id)
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