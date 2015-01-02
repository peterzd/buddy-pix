class SearchController < ApplicationController
  def search
    if search_params.blank?
      @cards = Album.order(updated_at: :desc).where(private: [nil, false])
    else
      type = search_params[:type]
      query = search_params[:query]
      case type
      when "card"
        @cards = search_for_cards(query)
      when "photo"
        @photos = search_for_photos(query)
      end
    end
  end

  def search_cards
    type = params[:type]
    query = params[:query]
    @cards = search_for_cards(query)
  end

  def search_photos

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
