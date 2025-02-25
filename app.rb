require "sinatra"
require "sinatra/reloader"
require "http" # required to place HTTP requests
require "dotenv/load" # required to use .env variables
require "json" # required to turn JSON string response into hashes and arrays

get("/") do
  exchange_rate_list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"

  raw_response = HTTP.get(exchange_rate_list_url) # HTML query
  parsed_response = JSON.parse(raw_response) # turn JSON response into arrays & hashes
  currency_list_hash = parsed_response.fetch("currencies") # isolate the currency list
  @currency_list_array = currency_list_hash.keys # put the three-letter currency codes into an array
  
  erb(:from_currency)
end

get("/:from_currency") do
  exchange_rate_list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"

  raw_response = HTTP.get(exchange_rate_list_url) # HTML query
  parsed_response = JSON.parse(raw_response) # turn JSON response into arrays & hashes
  currency_list_hash = parsed_response.fetch("currencies") # isolate the currency list
  @currency_list_array = currency_list_hash.keys # put the three-letter currency codes into an a

  @from_currency = params.fetch(:from_currency)
  erb(:to_currency)
end

get("/:from_currency/:to_currency") do
  #----------- query string key/value pairs ----------------
    @from_currency = params.fetch(:from_currency)
    @to_currency = params.fetch(:to_currency)
    amount = 1

  #------------ API call ----------------------------------
  conversion_url = "https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}&amount=#{amount}&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  raw_response = HTTP.get(conversion_url) # HTML query
  parsed_response = JSON.parse(raw_response) # turn JSON response into arrays & hashes
  @exchange_rate = parsed_response.fetch("result") # isolate FX rate response

  erb(:results)
end
