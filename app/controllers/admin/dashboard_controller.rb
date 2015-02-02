class Admin::DashboardController < Admin::ApplicationController
  def index
    @inactive_users = User.inactive_users

    @start_date = (params[:start_date] or 1.week.ago).to_date
    @end_date = (params[:end_date] or Date.today).to_date

    @registered_user_array, @posts_array, @cards_array = [], [], []
    @active_user_array, @likes_array, @comments_array = [], [], []

    (@start_date..@end_date).each_with_index do |date, i|
      @registered_user_array << [i+1, User.registered_per_day(date).count]
      @posts_array << [i+1, Photo.total_posts_per_day(date).count]
      @cards_array << [i+1, Album.total_cards_per_day(date).count]
      @likes_array << [i+1, Like.total_likes_per_day(date).count]
      @comments_array << [i+1, Comment.total_comments_per_day(date).count]
      @active_user_array << [i+1, User.active_users_per_day(date).count]
    end
  end
end
