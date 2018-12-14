class LandingPage < ApplicationRecord

  def compile_ejs
    Hash[html.map do |k,v|
      [k, EJS.evaluate(v, data).html_safe]
    end]
  end

end
