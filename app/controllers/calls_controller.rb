class CallsController < ApplicationController
  def index
    @calls = Call.includes(:neighbourhood).includes(:units).all
  end
end
