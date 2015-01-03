class SearchController < ApplicationController
  NUMBER_FACTOR = 1

  def search
    @cards = Album.order(updated_at: :desc).where(private: [nil, false], hidden: [nil, false]).limit(NUMBER_FACTOR).offset(0)
  end

  def search_batch
    page = params[:page].to_i - 1
    @cards = Album.order(updated_at: :desc).where(private: [nil, false], hidden: [nil, false]).limit(NUMBER_FACTOR).offset(page * NUMBER_FACTOR)
    if @cards.empty?
      render nothing: true, status: 404
    else
      render partial: "albums/card_detail", collection: @cards, as: :card
    end
  end

  def search_cards
    query = params[:query]
    @cards = search_for_cards(query)
  end

  def search_photos
    query = params[:query]
    @photos = search_for_photos(query)
  end

  private
  def search_params
    params[:search]
  end

  def search_for_cards(query)
    return Album.order(updated_at: :desc).where(private: [nil, false]) if query.blank?
    result = Album.search query
    result.results.inject([]) do |records, r|
      card = Album.where(id: r.id).first
      if card and card.visible_to_world?
        records << card
      else
        records
      end
    end
  end

  def search_for_photos(query)
    return Photo.all_visible_items if query.blank?
    result = Photo.search query
    result.results.inject([]) do |records, r|
      photo = Photo.where(id: r.id).first
      if photo and photo.visible_to_world?
        records << photo
      else
        records
      end
    end
  end
end
