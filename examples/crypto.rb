require_relative './examples_helper.rb'

res = TonSdk::Crypto.generate_random_sign_keys(@c_ctx.context)
if res.success?
  puts "random sign keys:"
  puts "\tpublic: #{res.result.public_}"
  puts "\tsecret: #{res.result.secret}"
  puts "\r\n"
end

pr1 = TonSdk::Crypto::ParamsOfFactorize.new("17ED48941A08F981")
res = TonSdk::Crypto.factorize(@c_ctx.context, pr1)
if res.success?
  puts 'factorize:'
  puts "\t#{res.result.factors}"
else
  puts "\terror: #{res.error}"
end


sleep(0.5)


def get_timeout_for_async_operation = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 5



class RegisterSigningBoxParamsMock
  attr_reader :public_, :private_

  def initialize(public_:, private_:)
    @public_ = public_
    @private_ = private_
  end

  def request(req)
    t = req["type"]
    case t
    when "GetPublicKey"
      res = TonSdk::Crypto::ResultOfAppSigningBox.new(
        type_: :get_public_key,
        public_key: @public_
      )

      [:success, res]
    else
      [:error, "request type #{t} isn't supported"]
    end
  end

  def notify = puts("notify")

  def to_h
    {
      public: @public_,
      private: @private_
    }
  end
end

# 1
@res = TonSdk::Crypto.generate_random_sign_keys(@c_ctx.context)
puts "pub key: #{@res.result.public_}"

# 2
reg_sb_mock = RegisterSigningBoxParamsMock.new(
  public_: @res.result.public_,
  private_: @res.result.secret
)


@res2 = TonSdk::Crypto.register_signing_box(@c_ctx.context, reg_sb_mock, is_single_thread_only: true)
timeout_at = get_timeout_for_async_operation()
sleep(0.1) until @res2 || (get_now_for_async_operation() >= timeout_at)

sb_handle = @res2.result.handle
puts "signinx box handle: #{sb_handle}"

# 3
pr3 = TonSdk::Crypto::RegisteredSigningBox.new(sb_handle)
@res3 = TonSdk::Crypto.signing_box_get_public_key(@c_ctx.context, pr3, is_single_thread_only: false)
timeout_at = get_timeout_for_async_operation()
sleep(0.1) until @res3 || (get_now_for_async_operation() >= timeout_at)

sleep(1)