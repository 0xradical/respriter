  class Locale

    LOCALE_REGEX = /(?<lang>[a-z]{2})(-(?<country>[A-Z]{2}))?/
    PG_REGEX = /\((?<lang>[a-z]{2}),(?<country>[A-Z]{2})?\)/
    ISO_3166 = ['AD','AE','AF','AG','AI','AL','AM','AO','AQ','AR','AS','AT','AU','AW','AX','AZ','BA','BB','BD','BE','BF','BG','BH','BI','BJ','BL','BM','BN','BO','BQ','BR','BS','BT','BV','BW','BY','BZ','CA','CC','CD','CF','CG','CH','CI','CK','CL','CM','CN','CO','CR','CU','CV','CW','CX','CY','CZ','DE','DJ','DK','DM','DO','DZ','EC','EE','EG','EH','ER','ES','ET','FI','FJ','FK','FM','FO','FR','GA','GB','GD','GE','GF','GG','GH','GI','GL','GM','GN','GP','GQ','GR','GS','GT','GU','GW','GY','HK','HM','HN','HR','HT','HU','ID','IE','IL','IM','IN','IO','IQ','IR','IS','IT','JE','JM','JO','JP','KE','KG','KH','KI','KM','KN','KP','KR','KW','KY','KZ','LA','LB','LC','LI','LK','LR','LS','LT','LU','LV','LY','MA','MC','MD','ME','MF','MG','MH','MK','ML','MM','MN','MO','MP','MQ','MR','MS','MT','MU','MV','MW','MX','MY','MZ','NA','NC','NE','NF','NG','NI','NL','NO','NP','NR','NU','NZ','OM','PA','PE','PF','PG','PH','PK','PL','PM','PN','PR','PS','PT','PW','PY','QA','RE','RO','RS','RU','RW','SA','SB','SC','SD','SE','SG','SH','SI','SJ','SK','SL','SM','SN','SO','SR','SS','ST','SV','SX','SY','SZ','TC','TD','TF','TG','TH','TJ','TK','TL','TM','TN','TO','TR','TT','TV','TW','TZ','UA','UG','UM','US','UY','UZ','VA','VC','VE','VG','VI','VN','VU','WF','WS','XK','YE','YT','ZA','ZM','ZW']
    ISO_6391 = ['aa','ab','ae','af','ak','am','an','ar','as','av','ay','az','ba','be','bg','bh','bi','bm','bn','bo','br','bs','ca','ce','ch','co','cr','cs','cu','cv','cy','da','de','dv','dz','ee','el','en','eo','es','et','eu','fa','ff','fi','fj','fo','fr','fy','ga','gd','gl','gn','gu','gv','ha','he','hi','ho','hr','ht','hu','hy','hz','ia','id','ie','ig','ii','ik','io','is','it','iu','ja','jv','ka','kg','ki','kj','kk','kl','km','kn','ko','kr','ks','ku','kv','kw','ky','la','lb','lg','li','ln','lo','lt','lu','lv','mg','mh','mi','mk','ml','mn','mr','ms','mt','my','na','nb','nd','ne','ng','nl','nn','no','nr','nv','ny','oc','oj','om','or','os','pa','pi','pl','ps','pt','qu','rm','rn','ro','ru','rw','sa','sc','sd','se','sg','si','sk','sl','sm','sn','so','sq','sr','ss','st','su','sv','sw','ta','te','tg','th','ti','tk','tl','tn','to','tr','ts','tt','tw','ty','ug','uk','ur','uz','ve','vi','vo','wa','wo','xh','yi','yo','za','zh','zu']

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
