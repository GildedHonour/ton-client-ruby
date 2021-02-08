require_relative './examples_helper.rb'


res = TonSdk::Client.version(@c_ctx.context)
if res.success?
  puts "version: #{res.result.version}"
else
  puts "error: #{res.error}"
end

res = TonSdk::Client.get_api_reference(@c_ctx.context)
if res.success?
  short_res = cut_off_long_string(res.result.api)
  puts "\r\nget_api_reference (first #{PRINT_RESULT_MAX_LEN} chars):\r\n#{short_res}"
else
  puts "error: #{res.error}"
end

res = TonSdk::Client.build_info(@c_ctx.context)
if res.success?
  puts "build_info build_number: #{res.result.build_number}"
  puts "build_info dependencies:"
  res.result.dependencies.each do |x|
    puts "    #{x.name}, #{x.git_commit}"
  end
else
  puts "error: #{res.error}"
end
