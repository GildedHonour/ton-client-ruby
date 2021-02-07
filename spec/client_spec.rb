require 'spec_helper'

describe TonSdk::Client do
  context "methods of client" do
    it "#version" do
      @res = TonSdk::Client.version(@c_ctx.context)
      expect(@res.success?).to eq true
      expect(@res.failure?).to_not eq true
    end

    it "#get_api_reference" do
      @res =TonSdk::Client.get_api_reference(@c_ctx.context)
      expect(@res.success?).to eq true
      expect(@res.failure?).to_not eq true
      expect(@res.result.api).to_not eq ""
    end

    it "#build_info" do
      @res = TonSdk::Client.build_info(@c_ctx.context)
      expect(@res.success?).to eq true
      expect(@res.failure?).to_not eq true
      expect(@res.result.build_number).to_not eq ""
      expect(@res.result.dependencies).to be_an_instance_of(Array)
    end
  end
end