class CreateIso639CodeType < ActiveRecord::Migration[5.2]
  def change
    execute "CREATE TYPE iso639_code AS ENUM ('ar-EG', 'ar-JO','ar-LB', 'ar-SY', 'de-DE',
    'en-AU','en-BZ', 'en-CA', 'en-GB', 'en-IN', 'en-NZ', 'en-US', 'en-ZA', 'es-AR', 'es-BO',
    'es-CL','es-CO', 'es-EC', 'es-ES', 'es-GT', 'es-MX', 'es-PE', 'es-VE', 'fr-BE', 'fr-CH',
    'fr-FR','it-IT', 'jp-JP', 'nl-BE', 'nl-NL', 'pl-PL', 'pt-BR', 'pt-PT', 'sv-SV', 'zh-CN',
    'zh-CMN','zh-HANS', 'zh-HANT', 'zh-TW', 'af', 'am','ar', 'az', 'be', 'bg', 'bn', 'bo', 'bs',
    'ca', 'co','cs', 'cy', 'da', 'de', 'el', 'en', 'eo', 'es', 'et', 'eu', 'fa', 'fi', 'fil', 'fr',
    'fy', 'ga','gd', 'gl', 'gu', 'ha', 'he', 'hi', 'hr', 'ht', 'hu', 'hy', 'id', 'ig', 'is', 'it',
    'iw', 'ja','jp', 'ka', 'kk', 'km', 'kn', 'ko', 'ku', 'ky', 'lb', 'lo', 'lt', 'lv', 'mg', 'mi',
    'mk', 'ml','mn', 'mr', 'ms', 'mt', 'my', 'nb', 'ne', 'nl', 'no', 'pa', 'pl', 'ps', 'pt', 'ro',
    'ru', 'rw','sd', 'si', 'sk', 'sl', 'sn', 'so', 'sq', 'sr', 'st', 'sv', 'sw', 'ta', 'te', 'tg',
    'th', 'tl','tr', 'tt', 'uk', 'ur', 'uz', 'vi', 'xh', 'yi', 'yo', 'zh', 'zu')"
  end
end
