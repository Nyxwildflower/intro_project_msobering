class ArtworksController < ApplicationController
  def index
    @artworks = Artwork.page(params[:page]).includes(:artist)
  end

  def show
    @artwork = Artwork.find(params[:id])
  end
end
