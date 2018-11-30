class LandingPage < ApplicationRecord

  def template
    <<-TEMPLATE
      <%= content_for :meta do %>
      #{meta_html}
      <% end %>
      #{body_html}
    TEMPLATE
  end

end
