class Admin::ReportsController < Admin::ApplicationController
  respond_to :html

  def index
    @start_date = 1.week.ago.to_date
    @end_date = Date.today
  end

  def query_range
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
  end
end
