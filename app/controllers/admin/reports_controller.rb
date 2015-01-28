class Admin::ReportsController < Admin::ApplicationController
  respond_to :html
  before_action :get_date

  def index
  end

  def cards_report
  end

  def inactive_users_report
    @inactive_users = User.inactive_users
  end

  private
  def get_date
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
  end
end
