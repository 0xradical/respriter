class FixLandingPages < ActiveRecord::Migration[5.2]
  def change
    LandingPage.all.each do |lp|
      lp.update(erb_template: lp.erb_template.gsub(/<%= asset_pack_path\('svg\/([a-zA-Z0-9_-]*).svg'\) %>/,'<%= asset_pack_path("svg/media/\1.svg") %>'))
    end
  end
end
