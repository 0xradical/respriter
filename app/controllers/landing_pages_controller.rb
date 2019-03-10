class LandingPagesController < ApplicationController

  def show
    @lp = LandingPage.find_by(slug: params[:id])
    template = LandingPageTemplate.new("#{@lp.template}.html.erb").fill_slots(@lp.slots)
    @lp.exec_context_script(self)
    render inline: template, layout: 'application'
  end

end
