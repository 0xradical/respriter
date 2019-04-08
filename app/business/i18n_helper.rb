class I18nHelper

  class << self

    def sanitize_locale(locale)
      return nil unless locale.present?
      root, region = locale.to_s.split('-')
      [root, region&.upcase].compact.join('-').to_sym
    end

    def root_language(locale=I18n.locale)
      locale.to_s.split('-')[0]
    end

  end

end
