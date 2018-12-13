class LandingPagesController < ApplicationController

  def show
    @lp = LandingPage.find_by(slug: params[:id])
    lp_tpl = LandingPageTemplate.new('courses.html.erb', {
      'HTTP_HOST'=>'localhost:3000',
      'HTTPS'=>'off',
      'REQUEST_METHOD'=>'GET',
      'SCRIPT_NAME'=>'',
      'warden' => warden
    })
    @lp.html.each { |k,v| @lp.html[k] = v.html_safe }
    render inline: lp_tpl.layout, layout: 'application', locals: { html: OpenStruct.new(@lp.html) }
  end

end
