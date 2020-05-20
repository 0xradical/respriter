class ProvidersController < ApplicationController

  def show
    @provider = Provider.find_by(slug: params[:id])
  end

end
