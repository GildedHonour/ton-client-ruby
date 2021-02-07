require_relative './examples_helper.rb'

res = TonSdk::Crypto.generate_random_sign_keys(@c_ctx.context)
if res.success?
  puts "random sign keys:"
  puts "  public: #{res.result.public_}"
  puts "  secret: #{res.result.secret}"
  puts "\r\n"
end

pr1 = TonSdk::Crypto::ParamsOfFactorize.new("17ED48941A08F981")
res = TonSdk::Crypto.factorize(@c_ctx.context, pr1)
if res.success?
  puts 'factorize:'
  puts "  #{res.result.factors}"
else
  puts "  error: #{res.error}"
end
