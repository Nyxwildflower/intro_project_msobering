class CallsController < ApplicationController
  def index
    @calls = Call.includes(:neighbourhood).includes(:units).all
  end

  def show
    @call = Call.find(params[:id])
  end
end
