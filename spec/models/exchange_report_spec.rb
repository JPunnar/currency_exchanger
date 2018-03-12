# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExchangeReport, type: :model do

  context "new instance" do
    before do
      @exchange_report = ExchangeReport.new
    end

    it "should not be valid" do
      expect(@exchange_report.valid?).to eq(false)
      expect(@exchange_report.errors.full_messages).to match_array([
        "Amount must be in 1 - 1000000",
        "Base currency not supported",
        "Max wait time in weeks must be in 1 - 250",
        "Target currency not supported",
        "User must exist"
      ])
    end

    it "base and target currency cannot be same" do
      @exchange_report.assign_attributes(base_currency: "EUR", target_currency: "EUR")
      @exchange_report.valid?
      expect(@exchange_report.errors.full_messages)
        .to include("Target currency can't be same as base currency")
    end
  end

  context "saved instance" do
    before do
      @exchange_report = Fabricate(:exchange_report)
    end

    it "should have calculated future dates" do
      expect(@exchange_report.future_dates).not_to be_empty
    end

    it "should select right rank class" do
      @exchange_report.exchange_rates << Fabricate(:exchange_rate, id: 1, prediction: 5)
      @exchange_report.update_columns(best_weeks_ids: @exchange_report.calculate_best_weeks_ids)
      expect(@exchange_report.rank_number(1)).to eq(1)

      @exchange_report.exchange_rates << Fabricate(:exchange_rate, id: 2, prediction: 10)
      @exchange_report.update_columns(best_weeks_ids: @exchange_report.calculate_best_weeks_ids)
      expect(@exchange_report.rank_number(1)).to eq(2)
      expect(@exchange_report.rank_number(2)).to eq(1)

      @exchange_report.exchange_rates << Fabricate(:exchange_rate, id: 3, prediction: 8)
      @exchange_report.update_columns(best_weeks_ids: @exchange_report.calculate_best_weeks_ids)
      expect(@exchange_report.rank_number(3)).to eq(2)
      expect(@exchange_report.rank_number(1)).to eq(3)
      expect(@exchange_report.rank_number(2)).to eq(1)
    end

    it "should correctly find top 3 rates" do
      @exchange_report.exchange_rates << Fabricate(:exchange_rate, id: 1, prediction: 5)
      @exchange_report.update_columns(best_weeks_ids: @exchange_report.calculate_best_weeks_ids)
      expect(@exchange_report.top_three?(1)).to eq(true)

      @exchange_report.exchange_rates << Fabricate(:exchange_rate, id: 2, prediction: 10)
      @exchange_report.update_columns(best_weeks_ids: @exchange_report.calculate_best_weeks_ids)
      expect(@exchange_report.top_three?(1)).to eq(true)
      expect(@exchange_report.top_three?(2)).to eq(true)

      @exchange_report.exchange_rates << Fabricate(:exchange_rate, id: 3, prediction: 8)
      @exchange_report.exchange_rates << Fabricate(:exchange_rate, id: 4, prediction: 9)
      @exchange_report.update_columns(best_weeks_ids: @exchange_report.calculate_best_weeks_ids)
      expect(@exchange_report.top_three?(3)).to eq(true)
      expect(@exchange_report.top_three?(1)).to eq(false)
      expect(@exchange_report.top_three?(2)).to eq(true)
      expect(@exchange_report.top_three?(4)).to eq(true)
    end

    it "should correctly calculate future dates" do
      expect(@exchange_report.future_dates.size).to eq(@exchange_report.max_wait_time_in_weeks + 1)
      @exchange_report.future_dates.each_with_index do |future_date, index|
        expect(future_date).to eq(Date.today + index.weeks)
      end
    end

    it "should not destroy associated rates when destroying itself" do
      expect { @exchange_report.destroy }.to change(ExchangeRate, :count).by(0)
    end

    it "should choose correctly classes for row coloring" do
      @exchange_report.max_wait_time_in_weeks.times do |index|
        @exchange_report.exchange_rates << Fabricate(:exchange_rate)
      end
      @exchange_report.exchange_rates.first.update_columns(rate: 5)
      @exchange_report.exchange_rates.last.update_columns(prediction: 6)
      expect(@exchange_report.color_class(@exchange_report.exchange_rates.last)).to eq("text-success")

      @exchange_report.exchange_rates.first.update_columns(rate: 6)
      @exchange_report.exchange_rates.last.update_columns(prediction: 5)
      expect(@exchange_report.color_class(@exchange_report.exchange_rates.last)).to eq("text-danger")
    end
  end
end
