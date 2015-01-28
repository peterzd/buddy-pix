class Admin::StaticPagesController < Admin::ApplicationController
  respond_to :html

  def index
    @pages = StaticPages.all
  end

  def edit
    @page = StaticPages.find params[:id]
  end

  def update
    @page = StaticPages.find params[:id]
    @page.update content: params[:static_pages][:content]
    redirect_to edit_admin_static_page_path @page
  end

end
