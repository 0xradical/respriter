class StaticPagesController < ApplicationController

  layout 'basic'

  def index
    render params[:page]
  end

end
