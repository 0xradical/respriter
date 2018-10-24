class PortalsController < ApplicationController

  def show
    @portal = Portal.find_by(slug: params[:id])
  end

end
