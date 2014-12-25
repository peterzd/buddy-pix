class SupportsController < ApplicationController
  before_action :set_support, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @supports = Support.all
    respond_with(@supports)
  end

  def show
    respond_with(@support)
  end

  def new
    @support = Support.new
    respond_with(@support)
  end

  def edit
  end

  def create
    @support = Support.new(support_params)

    if @support.save
      SupportMailer.support_email(@support).deliver
      flash[:success] = "your feedback is sent out. Thank you !"
      redirect_to welcome_support_path
    end
  end

  private
    def set_support
      @support = Support.find(params[:id])
    end

    def support_params
      params.require(:support).permit(:sender_name, :email, :subject, :message)
    end
end
