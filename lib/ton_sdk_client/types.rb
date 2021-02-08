module TonSdk
  class ResultOfConvertAddress
    attr_reader :address

    def initialize(a)
      @address = a
    end
  end

  class SdkError < StandardError
    attr_reader :code, :message, :data

    def initialize(code: nil, message: nil, data: nil)
      @code = code
      @message = message
      @data = data
    end
  end

  class NativeLibResponsetResult
    attr_reader :result, :error, :type_
    TYPES = [
      :success,
      :failure,
      :request,
      :notify,
      :custom
    ]

    # FIXME remove nil from type
    def initialize(type_: :success, result: nil, error: nil)
      unless TYPES.include?(type_)
        raise ArgumentError.new("type #{type_} is unknown; known types: #{TYPES}")
      end
      @type_ = type_

      if !result.nil? && !error.nil?
        raise ArgumentError.new('only either argument, result or error, should be specified')
      elsif !result.nil?
        @result = result
      elsif !error.nil?
        @error = SdkError.new(
          code: error["code"],
          message: error["message"],
          data: error["data"]
        )
      end

      self
    end

    def success? = !@result.nil?
    def failure? = !@error.nil?
  end
end