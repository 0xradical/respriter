module Slugifyable
  extend ActiveSupport::Concern

  include ActiveSupport::Inflector

  def build_slug
    string = self.class._transform_.kind_of?(Proc) ? self.class._transform_.call(self) : send(self.class._transform_)
    self[self.class._persist_on_] = transliterate(string.downcase).gsub(/\W+/, '-').chomp('-')
  end

  class_methods do

    def slugify(transform=nil, persist_on: nil, run_on: nil, callback_options: {})
      @transform, @persist_on, @callback = transform, persist_on, run_on
      self.send(_callback_, :build_slug, callback_options)
    end

    def _transform_
      @transform || :name
    end

    def _callback_
      @callback || :before_save
    end

    def _persist_on_
      @persist_on || :slug
    end

  end

end
