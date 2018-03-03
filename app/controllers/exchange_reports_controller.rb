class ExchangeReportsController < ApplicationController
  before_action :authenticate_user!

	def index
		@exchange_reports = current_user.exchange_reports
	end

	def new
		@exchange_report = ExchangeReport.new
	end

  def create
    @exchange_report = ExchangeReport.new(allowed_params)
    @exchange_report.user_id = current_user.id
    if @exchange_report.save
      @exchange_report.collect_data
      redirect_to @exchange_report
    else
      flash.now[:alert] = "Failed to create report"
      render :new
    end
  end

  def show
    @exchange_report = ExchangeReport.find(params[:id])
  end

  def destroy
    @exchange_report = ExchangeReport.find(params[:id])
    if @exchange_report.destroy
      redirect_to root_path
    else
      render :new
    end
  end

  def info
    
  end

  private

  def allowed_params
    params.require(:exchange_report).permit(:amount, :max_wait_time_in_weeks, :base_currency, :target_currency)
  end
end