module Elements
  class Railtie < ::Rails::Railtie

    initializer 'elements.initialize' do |app|
      ActionView::Base.send :include, AssetHelper
    end

  end
end
