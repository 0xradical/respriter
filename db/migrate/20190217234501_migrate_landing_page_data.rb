class MigrateLandingPageData < ActiveRecord::Migration[5.2]
  def change

    execute <<-SQL
      DELETE FROM landing_pages WHERE data::text = '{}'::text;
    SQL

    body_html = <<-TEMPLATE
    <div class=\\"grid-4w_desktop mx-D(n)@phone mx-D(n)@tablet\\">
      <% @courses.each do |course| %>
        <div style=\\"height:415px\\">
          <%= render \\"vcard\\", course: course %>
        </div>
      <% end %>
    </div>

    <script id=\\"courses\\" type=\\"x-vue-template\\">
      <swiper @ready=\\"function(){this.window.initVideoPlayers()}\\" :options=\\"{}\\">
      <swiper :options=\\"{}\\">
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
    UPDATE landing_pages SET html = jsonb_set(html, '{body}', '"#{body_html.delete("\n").strip}"');
    SQL

    LandingPage.find_each do |lp|
      course_ids = lp.data['courses'].map { |c| c['id'] }

      execute "UPDATE landing_pages SET data = '{ \"script\": [{ \"expose\": \"@courses\",
      \"context\": { \"resource\": \"Course\", \"methods\": [{\"name\": \"where\", \"args\": [{
      \"id\": #{course_ids}}]}]}}]}' WHERE id = #{lp.id}"

    end

  end
end
