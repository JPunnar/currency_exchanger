# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do

  context "new instance" do
    before do
      @user = User.new
    end

    it "should not be valid" do
      expect(@user.valid?).to eq(false)
      expect(@user.errors.full_messages).to match_array([
        "Email can't be blank",
        "Password can't be blank",
        "Username can't be blank"
      ])
    end
  end

  context "email and username" do
    before do
      @user = Fabricate(:user)
    end

    it "should not allow illegal chars" do
      @user.username = "@my_username"
      @user.email = "my_email,com"
      expect(@user.valid?).to eq(false)
      expect(@user.errors.full_messages).to match_array([
        "Email is invalid",
        "Username is invalid"
      ])
    end

    it "should be unique" do
      @user.email = "test@test.com"
      @user.username = "username"
      @user.save
      user2 = User.new(email: "test@test.com", username: "username", password: "testtest")
      expect(user2.valid?).to eq(false)
      expect(user2.errors.full_messages).to match_array([
        "Email has already been taken",
        "Username has already been taken"
      ])
    end
  end

  context "with exchange reports" do
    before do
      @user = Fabricate(:user)
      @user.exchange_reports << Fabricate(:exchange_report)
      @user.exchange_reports << Fabricate(:exchange_report)
    end

    it "should destroy its reports with itself" do
      expect { @user.destroy }.to change(ExchangeReport, :count).by(-2)
    end

    it "should not destroy associated rates when destroying itself" do
      @user.exchange_reports.first.exchange_rates << Fabricate(:exchange_rate)
      expect { @user.destroy }.to change(ExchangeRate, :count).by(0)
    end
  end
end
