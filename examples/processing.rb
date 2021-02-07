require_relative './examples_helper.rb'

cont_json = File.read("#{EXAMPLES_DATA_DIR}/contracts/abi_v2/Events.abi.json")
abi1 = TonSdk::Abi::Abi.new(
  type_: :contract,
  value: TonSdk::Abi::AbiContract.from_json(JSON.parse(cont_json))
)

tvc1_cont_bin = IO.binread("#{EXAMPLES_DATA_DIR}/contracts/abi_v2/Events.tvc")
tvc1 = Base64::strict_encode64(tvc1_cont_bin)
res = TonSdk::Crypto::generate_random_sign_keys(@c_ctx.context)
if res.success?
  @keys = res.result
end

sleep(0.1) until @keys

puts "keys public: #{@keys.public_}"
puts "keys secret: #{@keys.secret}"

encode_params = TonSdk::Abi::ParamsOfEncodeMessage.new(
  abi: abi1,
  deploy_set: TonSdk::Abi::DeploySet.new(
    tvc: tvc1
  ),
  call_set: TonSdk::Abi::CallSet.new(
    function_name: "constructor",
    header: TonSdk::Abi::FunctionHeader.new(
      pubkey: @keys.public_,
    ),
  ),
  signer: TonSdk::Abi::Signer.new(type_: :keys, keys: @keys)
)

cb = Proc.new do |a|
  puts "process_message > event: #{a}"
end

pr1 = TonSdk::Processing::ParamsOfProcessMessage.new(
  message_encode_params: encode_params,
  send_events: true
)

res = TonSdk::Processing.process_message(@c_ctx.context, pr1, cb)
p res

# required, to keep the main thread alive
loop do
  puts "[*] to interrupt the loop press Ctrl+C\r\n"
  sleep 1
end