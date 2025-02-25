require "http" # required to place HTTP requests
require "dotenv/load" # required to use .env variables
require "json" # required to turn JSON string response into hashes and arrays

# documentation on pulling full list of supported currencies (https://exchangerate.host/documentation)
# https://api.exchangerate.host/list
  # ? access_key = YOUR_ACCESS_KEY

exchange_rate_list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"

raw_response = HTTP.get(exchange_rate_list_url) # HTML query
parsed_response = JSON.parse(raw_response) # turn JSON response into arrays & hashes
# pp parsed_response

currency_list_hash = parsed_response.fetch("currencies") # isolate the currency list
# pp currency_list_hash

currency_list_array = currency_list_hash.keys # put the three-letter currency codes into an array
# pp currency_list_array

# documentation on converting one currency to another (https://exchangerate.host/documentation) 
# https://api.exchangerate.host/convert?from=EUR&to=GBP&amount=100

from_currency = "USD"
to_currency = "EUR"
amount = 1
conversion_url = "https://api.exchangerate.host/convert?from=#{from_currency}&to=#{to_currency}&amount=#{amount}&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  # order of query string doesn't seem to matter

raw_FX_response = HTTP.get(conversion_url)
# pp raw_FX_response
parsed_FX_response = JSON.parse(raw_FX_response)
# pp parsed_FX_response
exchange_rate = parsed_FX_response.fetch("result")
pp exchange_rate
