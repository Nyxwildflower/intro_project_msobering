class CallsController < ApplicationController
  def index
    @calls = Call.page(params[:page]).includes(:neighbourhood).includes(:units)
  end

  def show
    @call = Call.find(params[:id])
  end
end
