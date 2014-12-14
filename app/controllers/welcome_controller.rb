class WelcomeController < ApplicationController
  def index
  end

  def about_us
  end

  def terms
    @page = StaticPages.find_by name: "terms"
  end

  def blog
    @blogs = Blog.order(:created_at)
  end

  def support
    @support = Support.new
  end

  def privacy
  end
end
