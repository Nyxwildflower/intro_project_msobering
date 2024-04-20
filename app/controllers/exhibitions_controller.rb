class ExhibitionsController < ApplicationController
  def index
    @exhibitions = Exhibition.page(params[:page])
  end

  def show
    @exhibition = Exhibition.find(params[:id])
  end
end
