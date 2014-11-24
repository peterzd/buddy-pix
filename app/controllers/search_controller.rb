class SearchController < ApplicationController
  def search
    @cards = Album.order(updated_at: :desc).where(private: [nil, false])
  end

  def search_cards
    if params[:q].nil?
      @cards = []
    else
      @cards = Album.search params[:q]
    end
  end
end
