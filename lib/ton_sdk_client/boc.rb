module TonSdk
  module Boc

    #
    # types
    #

    class ParamsOfParse
      attr_reader :boc

      def initialize(a)
        @boc = a
      end

      def to_h = { boc: @boc }
    end

    class ResultOfParse
      attr_reader :parsed

      def initialize(a)
        @parsed = a
      end
    end

    class ParamsOfParseShardstate
      attr_reader :boc, :id, :workchain_id

      def initialize(boc:, id_:, workchain_id:)
        @boc = boc
        @id_ = id_
        @workchain_id = workchain_id
      end

      def to_h
        {
          boc: @boc,
          id: @id_,
          workchain_id: @workchain_id
        }
      end
    end

    class ParamsOfGetBlockchainConfig
      attr_reader :block_boc

      def initialize(a)
        @block_boc = a
      end

      def to_h
        {
          block_boc: @block_boc
        }
      end
    end

    class ResultOfGetBlockchainConfig
      attr_reader :config_boc

      def initialize(a)
        @config_boc = a
      end
    end

    class ParamsOfGetBocHash
      attr_reader :boc

      def initialize(a)
        @boc = a
      end

      def to_h
        {
          boc: @boc
        }
      end
    end

    class ResultOfGetBocHash
      attr_reader :hash

      def initialize(a)
        @hash = a
      end
    end

    class ParamsOfGetCodeFromTvc
      attr_reader :tvc

      def initialize(a)
        @tvc = a
      end

      def to_h
        {
          tvc: @tvc
        }
      end
    end

    class ResultOfGetCodeFromTvc
      attr_reader :code

      def initialize(a)
        @code = a
      end
    end



    #
    # functions
    #

    def self.parse_message(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.parse_message", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfParse.new(resp.result["parsed"])
        )
      else
        yield resp
      end
    end

    def self.parse_transaction(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.parse_transaction", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfParse.new(resp.result["parsed"])
        )
      else
        yield resp
      end
    end

    def self.parse_account(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.parse_account", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfParse.new(resp.result["parsed"])
        )
      else
        yield resp
      end
    end

    def self.parse_block(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.parse_block", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfParse.new(resp.result["parsed"])
        )
      else
        yield resp
      end
    end

    def self.parse_shardstate(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.parse_shardstate", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfParse.new(resp.result["parsed"])
        )
      else
        resp
      end
    end

    def self.get_blockchain_config(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.get_blockchain_config", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfGetBlockchainConfig.new(resp.result["config_boc"])
        )
      else
        resp
      end
    end

    def self.get_boc_hash(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.get_boc_hash", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfGetBocHash.new(resp.result["hash"])
        )
      else
        resp
      end
    end

    def self.get_code_from_tvc(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "boc.get_code_from_tvc", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: ResultOfGetCodeFromTvc.new(resp.result["code"])
        )
      else
        resp
      end
    end
  end
end