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
      when "image"
        @images = search_for_images(query)
        logger.info "the images are #{@images}"
      end
    end
  end

  private
  def search_params
    params[:search]
  end

  def search_for_cards(query)
    return Album.order(updated_at: :desc).where(private: [nil, false]) if query.blank?
    result = Album.search query
    result.results.inject([]) do |records, r|
      card = Album.find r.id
      if card.visible_to_world?
        records << card
      else
        records
      end
    end
  end

  def search_for_images(query)
  end
end
