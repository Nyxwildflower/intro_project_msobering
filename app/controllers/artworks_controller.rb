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
    @chosen_category = params[:category_sort]

    if params[:category_sort].blank?
      # Query for artwork title partial matches while avoiding SQL injection.
      @artworks = Artwork.where('title LIKE ?', "%#{@query}%").page(params[:page])
      @chosen_category = "any"
    else
      @artworks = Artwork.where('artworks.title LIKE ?', "%#{@query}%").includes(:categories).where('categories.title = ?', @chosen_category).references(:categories).page(params[:page])
    end

    # Return a count of all artworks.
    @count = @artworks.total_count
  end
end
