class ArtworksController < ApplicationController
  def index
    @artworks = Artwork.includes(:artist).all
  end
end
