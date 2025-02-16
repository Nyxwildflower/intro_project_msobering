class CallsController < ApplicationController
  def index
    @calls = Call.page(params[:page]).includes(:neighbourhood).includes(:units)

    # If parameters are sent from the search bar, and they're not blank,
    # the normal index variable is filtered down further by the search query.
    # The search is for incident type.
    if params[:search_by_incident] && params[:search_by_incident].strip != ""
      @query = params[:search_by_incident]

      @calls = @calls.where("incident_type LIKE ?", "%#{params[:search_by_incident]}%").page(params[:page])
      # Use kaminari's method to get the total count of paginated results.
      @count = @calls.total_count
    end

    if params[:search_by_neighbourhood] && !params[:search_by_neighbourhood].blank?
      @filter_query = params[:search_by_neighbourhood]

      # Filter current call variable further by neighbourhood name.
      @calls = @calls.where(neighbourhood: {name: params[:search_by_neighbourhood]}).page(params[:page])

      # Update count.
      @count = @calls.total_count
    end
  end

  def show
    @call = Call.find(params[:id])
  end
end
