require 'spec_helper'

describe TonSdk::Debot do

  # TODO in the main repository 'debot' is still unstable, as of 15 jan 2021
  # finish the tests once 'debot' has become stable

  context "methods of debot" do
    it "#start" do
      pr1 = TonSdk::Debot::ParamsOfStart.new("abc")
      @res = TonSdk::Debot.start(@c_ctx.context, pr1)

      # expect(@res.success?).to eq true
    end

    it "#fetch" do
    end

    it "#execute" do
    end

    it "#remove" do
    end
  end
end