class SearchController < ApplicationController
  NUMBER_FACTOR = 6

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
    @cards = search_for_cards(query, 1)
  end

  def search_cards_batch
    query = params[:query]
    page = params[:page].to_i
    @cards = search_for_cards(query, page)

    if @cards.empty?
      render nothing: true, status: 404
    else
      render partial: "albums/card_detail", collection: @cards, as: :card
    end
  end

  def search_photos
    query = params[:query]
    @photos = search_for_photos(query, 1)
  end

  def search_photos_batch
    query = params[:query]
    page = params[:page].to_i
    @photos = search_for_photos(query, page)

    # the logic here is not right, should check if there're more to query
    # if not, then return 404
    if @photos.empty?
      render nothing: true, status: 404
    else
      render partial: "albums/photo", collection: @photos, as: :photo, locals: { from: "search" }
    end
  end

  private
  def search_params
    params[:search]
  end

  def search_for_cards(query, page)
    return Album.order(updated_at: :desc).where(private: [nil, false]) if query.blank?
    result = Album.search(query).page(page).per(NUMBER_FACTOR).records
    result.results.inject([]) do |records, r|
      card = Album.where(id: r.id).first
      if card and card.visible_to_world?
        records << card
      else
        records
      end
    end
  end

  def search_for_photos(query, page)
    return Photo.all_visible_items if query.blank?
    result = Photo.search(query).page(page).per(NUMBER_FACTOR).records
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
