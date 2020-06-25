  class Locale

    LOCALE_REGEX = /(?<lang>[a-z]{2})(-(?<country>[A-Z]{2}))?/
    PG_REGEX = /\((?<lang>[a-z]{2}),(?<country>[A-Z]{2})?\)/
    ISO_3166, ISO_6391 = %w[app.iso3166_1_alpha2_code app.iso639_1_alpha2_code].map do |pg_enum_type|
      ActiveRecord::Base.connection.exec_query("select unnest(enum_range(NULL::#{pg_enum_type}))").map(&:values).flatten
    end

    attr_accessor :lang, :country

    class << self
      def from_string(locale_str)
        from_regex(locale_str, LOCALE_REGEX)
      end

      def from_pg(locale_str)
        from_regex(locale_str, PG_REGEX)
      end

      def to_pg_array(locales)
        quoted_locales = locales.map { |locale| '"' + locale.to_pg + '"' }
        "{#{quoted_locales.join(',')}}"
      end

      def from_pg_array(pg_str)
        pg_str.scan(PG_REGEX).map { |(lang, country)| new(lang, country) }
      end

      protected
      def from_regex(locale_str, regex)
        regex_match = locale_str.match(regex)
        new(*regex_match.values_at(:lang, :country))
      end
    end

    def initialize(lang, country=nil)
      @lang = lang if ISO_6391.include? lang
      @country = country if @lang.present? and ISO_3166.include? country
    end

    def language_only
      Locale.new(@lang)
    end

    def empty?
      @lang.nil?
    end

    def ==(other)
      @lang == other.lang && @country == other.country
    end

    def to_s
      @country.present? ? "#{@lang}-#{@country}" : "#{@lang}"
    end

    def to_pg
      "(#{@lang},#{@country})"
    end
  end
