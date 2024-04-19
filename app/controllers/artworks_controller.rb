class ArtworksController < ApplicationController
  def index
    @artworks = Artwork.includes(:artist).all
  end

  def show
    @artwork = Artwork.find(params[:id])
  end
end
