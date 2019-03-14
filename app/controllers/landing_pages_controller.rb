class LandingPagesController < ApplicationController

  def show
    @lp = LandingPage.find_by(slug: params[:id])
    @lp.exec_context_script(self)
    render inline: @lp.erb_template, layout: 'application'
  end

end
