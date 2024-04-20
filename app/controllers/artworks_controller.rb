class ArtworksController < ApplicationController
  def index
    @artworks = Artwork.page(params[:page]).includes(:artist)
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  # Action for searching.
  def search
    @query = params[:q]

    # Query for artwork title partial matches while avoiding SQL injection.
    @artworks = Artwork.where('title LIKE ?', "%#{@query}%").page(params[:page])

    # Return a count of all artworks.
    @count = @artworks.total_count
  end
end
