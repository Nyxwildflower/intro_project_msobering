class NeighbourhoodsController < ApplicationController
  def show
    @neighbourhood = Neighbourhood.find(params[:id])
  end
end
