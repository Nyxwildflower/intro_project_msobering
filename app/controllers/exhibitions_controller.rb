class ExhibitionsController < ApplicationController
  def index
    @exhibitions = Exhibition.all
  end

  def show
    @exhibition = Exhibition.find(params[:id])
  end
end
