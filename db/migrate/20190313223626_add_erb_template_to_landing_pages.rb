class AddErbTemplateToLandingPages < ActiveRecord::Migration[5.2]
  def change

    add_column :landing_pages, :erb_template, :text
    add_column :landing_pages, :layout, :string

    LandingPage.where("template != 'basic_hero_theme_2'").find_each do |lp|

      /<img src=(?:'|")?([a-zA-Z0-9.:\/\/]*)(?:'|")?.*>/.match(lp.html['tagline_art'])
      art = $1 || lp.html['hero_art']

      erb_tpl = <<-ERB_TEMPLATE
        <%= content_for :meta do %>
        <% end %>

        <div class="c-hero(2.0) c-hero(2.0)--bg-linear-gradient(#{lp.html['hero_bg_color'] || 'dark-blue'})">
          <div class='l-container'>
            <div class='c-hero(2.0)__art c-hero(2.0)__art--center-right' style="background-image:url(#{art});background-size: auto 65%">
              <div class='c-hero(2.0)__content c-hero(2.0)__content--giant-1'>

                <h1 class='c-title'>
                  #{lp.html['hero_title'] || lp.html['tagline']}
                </h1>

                <p class='mx-D(n)@phone c-hero(2.0)__text-slot mx-Mt(0d875)'>
                  #{lp.html['hero_text'] || lp.html['sub_title']}
                </p>

              </div>
            </div>
          </div>
        </div>

        <div class='l-container mx-Mt(40px)' style='margin-top:40px'>
          #{lp.html['body']}
        </div>
      ERB_TEMPLATE

      lp.erb_template = erb_tpl

      lp.save!

    end

    LandingPage.where("template = 'basic_hero_theme_2'").find_each do |lp|
      tpl = <<-TPL
        <%= content_for :meta do %>
        <% end %>

        <div class='c-hero(2.0) c-hero(2.0)--bg-flat(#{lp.html['hero_bg_color']})'>
          <div class='l-container'>
            <div class='c-hero(2.0)__art c-hero(2.0)__art--bottom-right c-hero(2.0)__art--landscape' style="background-image:url(<%= asset_pack_path(\'svg/#{lp.html['hero_art']}\') %>)">
              <div class='c-hero(2.0)__content c-hero(2.0)__content--giant-1'>

                <h1 class='c-title-impact c-hero(2.0)__title-slot'>
                  #{lp.html['hero_title']}
                  <span class='c-title-impact__superscript'></span>
                </h1>

                <p class='mx-D(n)@phone c-hero(2.0)__text-slot mx-Mt(0d875)'>
                  #{lp.html['hero_text']}
                </p>

              </div>
            </div>
          </div>
        </div>

        <div class='l-container mx-Mt(40px)' style='margin-top:40px'>
          #{lp.html['body']}
        </div>
      TPL

      lp.erb_template = tpl

      lp.save!

    end



  end
end
