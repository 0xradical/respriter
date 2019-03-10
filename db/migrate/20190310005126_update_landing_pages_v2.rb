class UpdateLandingPagesV2 < ActiveRecord::Migration[5.2]
  def change
    body_html = <<-TEMPLATE
      <div class=\\"grid-4w_desktop mx-D(n)@phone mx-D(n)@tablet\\">
        <% @courses.each do |course| %>
          <div style=\\"height:448px\\">
            <%= render \\"vcard\\", course: course %>
          </div>
        <% end %>
      </div>

      <script id=\\"courses\\" type=\\"x-vue-template\\">
        <swiper @ready=\\"function(){this.window.initVideoPlayers()}\\" :options=\\"{}\\">
          <% @courses.each do |course|%>
            <swiper-slide>
              <%= render \\"vcard\\", course: course %>
            </swiper-slide> 
          <% end %>
        </swiper>
      </script>

      <div class=\\"mx-D(n)@desktop mx-D(n)@tv\\">
        <div data-vue-cpt=\\"courses\\"></div>
      </div>
    TEMPLATE

    execute <<-SQL
      UPDATE landing_pages SET html = jsonb_set(html, '{body}', '"#{body_html.gsub("415px","448px").delete("\n").strip}"');
      UPDATE landing_pages SET template = 'basic_hero_theme_2' WHERE slug ILIKE '%become%';
    SQL

    LandingPage.where("slug ILIKE '%become%'").each do |lp|
      html = lp.html
      html['hero_title'] = html['tagline']
      html['hero_text'] = html['sub_title']
      html['hero_art'] = ''
      html['hero_bg_color'] = ''
      html.delete('tagline_art')
      html.delete('tagline')
      html.delete('sub_title')
      lp.update!(html: html)
    end


  end
end
