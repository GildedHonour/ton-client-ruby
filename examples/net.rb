require_relative './examples_helper.rb'


p1 = TonSdk::Net::ParamsOfQueryCollection.new(
  collection: "blocks_signatures", 
  result: "id",
  limit: 1
)
res = TonSdk::Net.query_collection(@c_ctx.context, p1)
if res.success?
  puts "net_query_collection#1: #{res.result.result}\r\n\r\n"
end


p2 = TonSdk::Net::ParamsOfQueryCollection.new(
  collection: "accounts",
  filter: {
    id: {
      in: [
          "0:841288ed3b55d9cdafa806807f02a0ae0c169aa5edfe88a789a6482429756a94",
          "0:2bb4a0e8391e7ea8877f4825064924bd41ce110fce97e939d3323999e1efbb13",
          "0:5b168970a9c63dd5c42a6afbcf706ef652476bb8960a22e1d8a2ad148e60c0ea"
      ]
    }
  },
  result: "id balance"
)

res = TonSdk::Net.query_collection(@c_ctx.context, p2)
if res.success?
  puts "net_query_collection#2: #{res.result.result}\r\n\r\n"
else
  puts "error: #{res.error}"
end


p3 = TonSdk::Net::ParamsOfQueryCollection.new(
  collection: "accounts", 
  result: "id balance",
)
res = TonSdk::Net.query_collection(@c_ctx.context, p3)
if res.success?
  puts "net_query_collection#3: #{res.result.result}\r\n\r\n"
end


p4 = TonSdk::Net::ParamsOfWaitForCollection.new(
  collection: "transactions",
  result: "id now",
)

res = TonSdk::Net.wait_for_collection(@c_ctx.context, p4)
if res.success?
  puts "net_wait_for_collection: #{res.result.result}\r\n\r\n"
end


p5 = TonSdk::Net::ParamsOfSubscribeCollection.new(
  collection: "transactions",
  result: "id account_addr",
)

response_callback = Proc.new do |a|
  puts "response_callback: #{a}"
end

Thread.new do
  res = TonSdk::Net.subscribe_collection(@c_ctx.context, p5, client_callback: response_callback)
  if res.success?
    puts "net_subscribe_collection: #{res.result.handle}"
  else
    puts "error #{res.error}"
  end
end


# required, to keep the main thread alive
loop do
  puts "[*] to interrupt the loop press Ctrl+C\r\n"
  sleep 1
end