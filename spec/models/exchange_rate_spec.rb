# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExchangeRate, type: :model do

  context "new instance" do
    before do
      @exchange_rate = ExchangeRate.new
    end

    it "should not be valid" do
      expect(@exchange_rate.valid?).to eq(false)
      expect(@exchange_rate.errors.full_messages).to match_array([
        "Base currency can't be blank",
        "Date can't be blank",
        "Rate can't be blank",
        "Target currency can't be blank"
      ])
    end
  end

  context "saved instance" do
    before do
      @exchange_rate = Fabricate(:exchange_rate)
    end

    it "should have calculated prediction" do
      expect(@exchange_rate.prediction).not_to eq(nil)
    end

    it "should require presence of prediction" do
      @exchange_rate.prediction = nil
      expect(@exchange_rate.valid?).to eq(false)
      expect(@exchange_rate.errors.full_messages)
        .to include("Prediction can't be blank")
    end
  end
end
