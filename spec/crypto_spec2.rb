
require 'spec_helper'
require 'base64'

describe TonSdk::Crypto do
  context "methods of crypto" do
    it "register_signing_box2" do

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

      # 1
      @res = TonSdk::Crypto.generate_random_sign_keys(@c_ctx.context, is_single_thread_only: true)
      expect(@res.success?).to eq true
      expect(@res.result.public_.length).to eq 64
      expect(@res.result.secret.length).to eq 64

      # # 2
      pr2 = RegisterSigningBoxParamsMock.new(
        public_: @res.result.public_,
        private_: @res.result.secret
      )

      puts "*** original public key: #{@res.result.public_}"


      @res2 = TonSdk::Crypto.register_signing_box(@c_ctx.context, is_single_thread_only: true)
      timeout_at = get_timeout_for_async_operation()
      sleep(0.1) until @res2 || (get_now_for_async_operation() >= timeout_at)

      expect(@res2.success?).to eq true
      sb_handle = @res2.result.handle
      expect(sb_handle).to_not eq nil


      # # 3
      pr3 = TonSdk::Crypto::RegisteredSigningBox.new(sb_handle)
      @res3 = TonSdk::Crypto.signing_box_get_public_key(@c_ctx.context, pr3)
      timeout_at = get_timeout_for_async_operation()
      sleep(0.1) until @res3 || (get_now_for_async_operation() >= timeout_at)


      expect(@res3.success?).to eq true

      p "*** success?: #{@res3.success?}"
      expect(@res3.result.pubkey).to eq @res.result.public_


    end


  end
end
