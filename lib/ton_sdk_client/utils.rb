module TonSdk
  module Utils

    #
    # types
    #

    class AddressStringFormat
      TYPES = [:account_id, :hex, :base64]
      attr_reader :type_, :url, :test_, :bounce

      def initialize(type_:, url: nil, test_: nil, bounce: nil)
        unless TYPES.include?(type_)
          raise ArgumentError.new("type #{type_} is unknown; known types: #{TYPES}")
        end

        @type_ = type_
        if @type_ == :base64
          @url = url
          @test_ = test_
          @bounce = bounce
        end
      end

      def to_h
        {
          type: Helper.sym_to_capitalized_case_str(@type_),
          url: @url,
          test: @test_,
          bounce: @bounce
        }
      end
    end

    class ParamsOfConvertAddress
      attr_reader :address, :output_format

      def initialize(address:, output_format:)
        @address = address
        @output_format = output_format
      end

      def to_h
        {
          address: @address,
          output_format: @output_format.to_h
        }
      end
    end

    class ResultOfConvertAddress
      attr_reader :address

      def initialize(a)
        @address = a
      end
    end


    #
    # functions
    #

    def self.convert_address(ctx, params)
      resp = Interop::request_to_native_lib(ctx, "utils.convert_address", params.to_h.to_json)
      if resp.success?
        NativeLibResponsetResult.new(
          result: Utils::ResultOfConvertAddress.new(resp.result["address"])
        )
      else
        resp
      end
    end
  end
end