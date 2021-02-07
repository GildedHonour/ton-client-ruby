require_relative './examples_helper.rb'

# TonSdk::Crypto.generate_random_sign_keys(@c_ctx.context) do |res|
#   if res.success?
#     puts "random sign keys:"
#     puts "  public: #{res.result.public_}"
#     puts "  secret: #{res.result.secret}"
#     puts "\r\n"
#   end
# end

# pr1 = TonSdk::Crypto::ParamsOfFactorize.new("17ED48941A08F981")
# TonSdk::Crypto.factorize(@c_ctx.context, pr1) do |res|
#   if res.success?
#     puts 'factorize:'
#     puts "  #{res.result.factors}"
#   else
#     puts "  error: #{res.error}"
#   end
# end



class RegisterSigningBoxParamsMock
  attr_reader :public_, :private_

  def initialize(public_:, private_:)
    @public_ = public_
    @private_ = private_
  end

  def request(a, b, c)
    raise "not yet implemented"
  end

  def notify = puts("notify")

  def to_h
    {
      public: @public_,
      private: @private_
    }
  end
end


# todo
# TonSdk::Crypto.generate_random_sign_keys(@c_ctx.context) do |res|
#   puts "***generate_random_sign_keys > user > callback"
#   puts a


#       # expect(@res.success?).to eq true
#       # expect(@res.result.public_.length).to eq 64
#       # expect(@res.result.secret.length).to eq 64

# end


res1 = TonSdk::Crypto.generate_random_sign_keys(@c_ctx.context)
p "res1: #{res1}"
