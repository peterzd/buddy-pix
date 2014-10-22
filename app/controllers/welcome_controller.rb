class WelcomeController < ApplicationController
  def index
  end

  def about_us
  end

  def terms
  end

  def blog
    @blogs = Blog.order(:created_at)
  end

  def support
  end

  def privacy
  end
end
