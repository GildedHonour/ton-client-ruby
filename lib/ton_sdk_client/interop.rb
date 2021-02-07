require 'ffi'
require 'rbconfig'
require 'concurrent'
require 'logger'

module TonSdk
  module Interop
    extend FFI::Library

    logger = Logger.new(STDOUT)

    class TcStringData < FFI::Struct
      layout :content, :pointer,
        :len, :uint32

      def self.from_string(s)
        tcs = TcStringData.new
        bytes_count = s.unpack("C*").size
        ptr1 = FFI::MemoryPointer.new(:char, bytes_count)
        ptr1.put_bytes(0, s, 0, bytes_count)
        tcs[:content] = ptr1
        tcs[:len] = ptr1.size
        tcs
      end
    end

    class TcResponse < FFI::Struct
      layout :result_json, TcStringData,
        :error_json, TcStringData
    end

    DEFAULT_LIB_NAME = 'tonclient'
    base_lib_name2 = case RbConfig::CONFIG['host_os']
    when /linux/
      'linux'
    when /darwin/
      'darwin'
    when /mswin|mingw32|windows/
      'win32'
    else
      raise "unsupported OS: #{RbConfig::CONFIG['host_os']}"
    end

    lib_full_name = if !ENV['TON_CLIENT_NATIVE_LIB_NAME'].nil?
      ENV['TON_CLIENT_NATIVE_LIB_NAME']
    else
      fl_nm = "#{DEFAULT_LIB_NAME}.#{FFI::Platform::LIBSUFFIX}"
      File.join(File.expand_path(File.dirname(File.dirname(__dir__))), fl_nm)
    end

    ffi_lib(lib_full_name)




    #
    # in C
    #
    # enum tc_response_types_t {
    #   tc_response_success = 0,
    #   tc_response_error = 1,
    #   tc_response_nop = 2,
    #   tc_response_custom = 100,
    # };
    module TcResponseCodes
      SUCCESS = 0
      ERROR = 1
      NOP = 2
      APP_REQUEST = 3
      APP_NOTIFY = 4
      CUSTOM = 100
    end


    #
    # in C
    #
    # tc_string_handle_t* tc_create_context(tc_string_data_t config);
    # void tc_destroy_context(uint32_t context);

    attach_function(:tc_create_context, [TcStringData.by_value], :pointer)
    attach_function(:tc_destroy_context, [:uint32], :void)


    #
    # in C
    #
    # tc_string_data_t tc_read_string(const tc_string_handle_t* string);
    # void tc_destroy_string(const tc_string_handle_t* string);

    attach_function(:tc_read_string, [:pointer], TcStringData.by_value)
    attach_function(:tc_destroy_string, [:pointer], :void)


    #
    # in C
    #
    # void tc_request(
    #   uint32_t context,
    #   tc_string_data_t function_name,
    #   tc_string_data_t function_params_json,
    #   uint32_t request_id,
    #   tc_response_handler_t response_handler);

    # typedef void (*tc_response_handler_t)(
    #   uint32_t request_id,
    #   tc_string_data_t params_json,
    #   uint32_t response_type,
    #   bool finished);

    callback(:tc_response_handler, [:uint32, TcStringData.by_value, :uint32, :bool], :void)
    attach_function(:tc_request, [:uint32, TcStringData.by_value, TcStringData.by_value, :uint32, :tc_response_handler], :void) # TODO possibly blocking: true

    #
    # in C
    #
    # tc_string_handle_t* tc_request_sync(
    #   uint32_t context,
    #   tc_string_data_t function_name,
    #   tc_string_data_t function_params_json);
    attach_function(:tc_request_sync, [:uint32, TcStringData.by_value, TcStringData.by_value], :pointer)



    @@request_counter = Concurrent::AtomicFixnum.new(1)

    def self.request_to_native_lib(
      ctx,
      function_name,
      function_params_json = nil,
      single_thread_only: true
    )
      function_name_tc_str = TcStringData.from_string(function_name)
      function_params_json_str = function_params_json || ""
      function_params_json_tc_str = TcStringData.from_string(function_params_json_str)

      sm = Concurrent::Semaphore.new(1)
      if single_thread_only == true
        sm.acquire()
      end


      # using @@request_counter here to pass a @@request_counter and handlers and then retrieve them
      # is probably isn't needed.
      # Thanks to the way Ruby is, the same affect can be achived by a block which is an easier way.
      # Nonetheless, @@request_counter is incremented with each request and then sent out to a server
      # in order to keep a server happy,
      # because otherwise a server will, probably, reply in a wrong way.

      self.tc_request(
        ctx,
        function_name_tc_str,
        function_params_json_tc_str,
        @@request_counter.value
      ) do |req_id, params_json, response_type, is_finished|

        tc_data_json_content = if params_json[:len] > 0
          res = params_json[:content].read_string(params_json[:len])
          JSON.parse(res)
        else
          ''
        end


            # todo
            # puts "\r\n*** #{function_name} > TcResponseCode #{response_type}; #{tc_data_json_content}; is_finished: #{is_finished}"

        begin
          @ret = case response_type
          when TcResponseCodes::SUCCESS
            NativeLibResponsetResult.new(type_: :success, result: tc_data_json_content)
  
          when TcResponseCodes::ERROR
            NativeLibResponsetResult.new(type_: :error, error: tc_data_json_content)

          when TcResponseCodes::NOP
            nil


          # TODO
          when TcResponseCodes::APP_REQUEST
            NativeLibResponsetResult.new(type_: :request, result: tc_data_json_content)



          when TcResponseCodes::APP_NOTIFY
            NativeLibResponsetResult.new(type_: :notify, result: tc_data_json_content)

          # TODO
          # think of a return value, namely, calling a block via 'yield',
          # for the cases when response_type isn't equal to 'SUCCESS' or 'ERROR';
          # as for the time being, it'll be called with success and "" (empty string) as a value

          when TcResponseCodes::CUSTOM
            NativeLibResponsetResult.new(type_: :custom, result: nil)


          else
            raise ArgumentError.new("unsupported response type: #{response_type}")
          end

        rescue => e
          logger.error(e)
          @ret = e
        ensure
          if single_thread_only == true
            sm.release()
          end
        end
      end

      if single_thread_only == true
        sm.acquire()
      end

      @@request_counter.increment()
      @ret
    end
  end
end