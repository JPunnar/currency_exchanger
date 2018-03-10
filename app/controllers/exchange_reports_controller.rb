# frozen_string_literal: true

class ExchangeReportsController < ApplicationController
  before_action :authenticate_user!, except: [:info]
  load_and_authorize_resource except: [:info]

  def index

  end

  def new

  end

  def create
    if @exchange_report.save
      @exchange_report.collect_data
      redirect_to @exchange_report
    else
      flash.now[:alert] = "Failed to create report"
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    if @exchange_report.update_attributes(exchange_report_params)
      @exchange_report.collect_data
      redirect_to @exchange_report
    else
      flash.now[:alert] = "Failed to update report"
      render :edit
    end
  end

  def destroy
    if @exchange_report.destroy
      redirect_to root_path
    else
      flash.now[:alert] = "Failed to delete report"
      render :index
    end
  end

  def info; end

  private

    def exchange_report_params
      params.require(:exchange_report).permit(:amount, :max_wait_time_in_weeks, :base_currency, :target_currency)
    end
end
