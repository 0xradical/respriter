# OLD, DEPRECATED CODE. WON'T WORK.
# url = page_version.data[:start_dates][0][:option][:course_url].gsub(/\?.*/, '').try(:strip) rescue raise('missing url')

# languages = {
#   'Afrikaans'                    => 'af',
#   'Albanian'                     => 'sq',
#   'Arabic (Standard)'            => 'ar',
#   'Arabic (Algeria)'             => 'ar-dz',
#   'Arabic (Bahrain)'             => 'ar-bh',
#   'Arabic (Egypt)'               => 'ar-eg',
#   'Arabic (Iraq)'                => 'ar-iq',
#   'Arabic (Jordan)'              => 'ar-jo',
#   'Arabic (Kuwait)'              => 'ar-kw',
#   'Arabic (Lebanon)'             => 'ar-lb',
#   'Arabic (Libya)'               => 'ar-ly',
#   'Arabic (Morocco)'             => 'ar-ma',
#   'Arabic (Oman)'                => 'ar-om',
#   'Arabic (Qatar)'               => 'ar-qa',
#   'Arabic (Saudi Arabia)'        => 'ar-sa',
#   'Arabic (Syria)'               => 'ar-sy',
#   'Arabic (Tunisia)'             => 'ar-tn',
#   'Arabic (U.A.E.)'              => 'ar-ae',
#   'Arabic (Yemen)'               => 'ar-ye',
#   'Aragonese'                    => 'an',
#   'Armenian'                     => 'hy',
#   'Assamese'                     => 'as',
#   'Asturian'                     => 'ast',
#   'Azerbaijani'                  => 'az',
#   'Basque'                       => 'eu',
#   'Belarusian'                   => 'be',
#   'Bengali'                      => 'bn',
#   'Bosnian'                      => 'bs',
#   'Breton'                       => 'br',
#   'Bulgarian'                    => 'bg',
#   'Burmese'                      => 'my',
#   'Catalan'                      => 'ca',
#   'Chamorro'                     => 'ch',
#   'Chechen'                      => 'ce',
#   'Chinese'                      => 'zh',
#   'Chinese (Hong Kong)'          => 'zh-hk',
#   'Chinese (PRC)'                => 'zh-cn',
#   'Chinese (Singapore)'          => 'zh-sg',
#   'Chinese (Taiwan)'             => 'zh-tw',
#   'Chuvash'                      => 'cv',
#   'Corsican'                     => 'co',
#   'Cree'                         => 'cr',
#   'Croatian'                     => 'hr',
#   'Czech'                        => 'cs',
#   'Danish'                       => 'da',
#   'Dutch (Standard)'             => 'nl',
#   'Dutch (Belgian)'              => 'nl-be',
#   'English'                      => 'en',
#   'English (Australia)'          => 'en-au',
#   'English (Belize)'             => 'en-bz',
#   'English (Canada)'             => 'en-ca',
#   'English (Ireland)'            => 'en-ie',
#   'English (Jamaica)'            => 'en-jm',
#   'English (New Zealand)'        => 'en-nz',
#   'English (Philippines)'        => 'en-ph',
#   'English (South Africa)'       => 'en-za',
#   'English (Trinidad & Tobago)'  => 'en-tt',
#   'English (United Kingdom)'     => 'en-gb',
#   'English (United States)'      => 'en-us',
#   'English (Zimbabwe)'           => 'en-zw',
#   'Esperanto'                    => 'eo',
#   'Estonian'                     => 'et',
#   'Faeroese'                     => 'fo',
#   'Farsi'                        => 'fa',
#   'Fijian'                       => 'fj',
#   'Finnish'                      => 'fi',
#   'French (Standard)'            => 'fr',
#   'French (Belgium)'             => 'fr-be',
#   'French (Canada)'              => 'fr-ca',
#   'French (France)'              => 'fr-fr',
#   'French (Luxembourg)'          => 'fr-lu',
#   'French (Monaco)'              => 'fr-mc',
#   'French (Switzerland)'         => 'fr-ch',
#   'Frisian'                      => 'fy',
#   'Friulian'                     => 'fur',
#   'Gaelic (Scots)'               => 'gd',
#   'Gaelic (Irish)'               => 'gd-ie',
#   'Galacian'                     => 'gl',
#   'Georgian'                     => 'ka',
#   'German (Standard)'            => 'de',
#   'German (Austria)'             => 'de-at',
#   'German (Germany)'             => 'de-de',
#   'German (Liechtenstein)'       => 'de-li',
#   'German (Luxembourg)'          => 'de-lu',
#   'German (Switzerland)'         => 'de-ch',
#   'Greek'                        => 'el',
#   'Gujurati'                     => 'gu',
#   'Haitian'                      => 'ht',
#   'Hebrew'                       => 'he',
#   'Hindi'                        => 'hi',
#   'Hungarian'                    => 'hu',
#   'Icelandic'                    => 'is',
#   'Indonesian'                   => 'id',
#   'Inuktitut'                    => 'iu',
#   'Irish'                        => 'ga',
#   'Italian (Standard)'           => 'it',
#   'Italian (Switzerland)'        => 'it-ch',
#   'Japanese'                     => 'ja',
#   'Kannada'                      => 'kn',
#   'Kashmiri'                     => 'ks',
#   'Kazakh'                       => 'kk',
#   'Khmer'                        => 'km',
#   'Kirghiz'                      => 'ky',
#   'Klingon'                      => 'tlh',
#   'Korean'                       => 'ko',
#   'Korean (North Korea)'         => 'ko-kp',
#   'Korean (South Korea)'         => 'ko-kr',
#   'Latin'                        => 'la',
#   'Latvian'                      => 'lv',
#   'Lithuanian'                   => 'lt',
#   'Luxembourgish'                => 'lb',
#   'FYRO Macedonian'              => 'mk',
#   'Malay'                        => 'ms',
#   'Malayalam'                    => 'ml',
#   'Maltese'                      => 'mt',
#   'Maori'                        => 'mi',
#   'Marathi'                      => 'mr',
#   'Moldavian'                    => 'mo',
#   'Navajo'                       => 'nv',
#   'Ndonga'                       => 'ng',
#   'Nepali'                       => 'ne',
#   'Norwegian'                    => 'no',
#   'Norwegian (Bokmal)'           => 'nb',
#   'Norwegian (Nynorsk)'          => 'nn',
#   'Occitan'                      => 'oc',
#   'Oriya'                        => 'or',
#   'Oromo'                        => 'om',
#   'Persian/Iran'                 => 'fa-ir',
#   'Polish'                       => 'pl',
#   'Portuguese'                   => 'pt',
#   'Portuguese (Brazil)'          => 'pt-br',
#   'Punjabi'                      => 'pa',
#   'Punjabi (India)'              => 'pa-in',
#   'Punjabi (Pakistan)'           => 'pa-pk',
#   'Quechua'                      => 'qu',
#   'Rhaeto-Romanic'               => 'rm',
#   'Romanian'                     => 'ro',
#   'Romanian (Moldavia)'          => 'ro-mo',
#   'Russian'                      => 'ru',
#   'Russian (Moldavia)'           => 'ru-mo',
#   'Sami (Lappish)'               => 'sz',
#   'Sango'                        => 'sg',
#   'Sanskrit'                     => 'sa',
#   'Sardinian'                    => 'sc',
#   'Sindhi'                       => 'sd',
#   'Singhalese'                   => 'si',
#   'Serbian'                      => 'sr',
#   'Slovak'                       => 'sk',
#   'Slovenian'                    => 'sl',
#   'Somani'                       => 'so',
#   'Sorbian'                      => 'sb',
#   'Spanish'                      => 'es',
#   'Spanish (Argentina)'          => 'es-ar',
#   'Spanish (Bolivia)'            => 'es-bo',
#   'Spanish (Chile)'              => 'es-cl',
#   'Spanish (Colombia)'           => 'es-co',
#   'Spanish (Costa Rica)'         => 'es-cr',
#   'Spanish (Dominican Republic)' => 'es-do',
#   'Spanish (Ecuador)'            => 'es-ec',
#   'Spanish (El Salvador)'        => 'es-sv',
#   'Spanish (Guatemala)'          => 'es-gt',
#   'Spanish (Honduras)'           => 'es-hn',
#   'Spanish (Mexico)'             => 'es-mx',
#   'Spanish (Nicaragua)'          => 'es-ni',
#   'Spanish (Panama)'             => 'es-pa',
#   'Spanish (Paraguay)'           => 'es-py',
#   'Spanish (Peru)'               => 'es-pe',
#   'Spanish (Puerto Rico)'        => 'es-pr',
#   'Spanish (Spain)'              => 'es-es',
#   'Spanish (Uruguay)'            => 'es-uy',
#   'Spanish (Venezuela)'          => 'es-ve',
#   'Sutu'                         => 'sx',
#   'Swahili'                      => 'sw',
#   'Swedish'                      => 'sv',
#   'Swedish (Finland)'            => 'sv-fi',
#   'Swedish (Sweden)'             => 'sv-sv',
#   'Tamil'                        => 'ta',
#   'Tatar'                        => 'tt',
#   'Teluga'                       => 'te',
#   'Thai'                         => 'th',
#   'Tigre'                        => 'tig',
#   'Tsonga'                       => 'ts',
#   'Tswana'                       => 'tn',
#   'Turkish'                      => 'tr',
#   'Turkmen'                      => 'tk',
#   'Ukrainian'                    => 'uk',
#   'Upper Sorbian'                => 'hsb',
#   'Urdu'                         => 'ur',
#   'Venda'                        => 've',
#   'Vietnamese'                   => 'vi',
#   'Volapuk'                      => 'vo',
#   'Walloon'                      => 'wa',
#   'Welsh'                        => 'cy',
#   'Xhosa'                        => 'xh',
#   'Yiddish'                      => 'ji',
#   'Zulu'                         => 'zu'
# }

# price = free_content = paid_content = nil
# case cost_description = page_version.data[:cost_description].strip
# when 'Paid Course'
#   free_content = false
#   paid_content = true
# when 'Free Online Course (Audit)'
#   free_content = true
#   paid_content = true
# when 'Free Online Course'
#   free_content = true
#   paid_content = false
# else
#   price        = cost_description.match(/\d+/)[0].to_i
#   free_content = false
#   paid_content = true
# end

# duration = workload = effort = nil
# if page_version.data[:duration].present?
#   case page_version.data[:duration].strip
#   when /^(\d+)\s*\-\s*(\d+) weeks long$/
#     duration = (($1.to_f + $2.to_f) / 2).round
#   when /^(\d+) weeks long$/
#     duration = $1.to_i
#   end
# end

# if page_version.data[:effort].present?
#   case page_version.data[:effort].strip
#   when /^(\d+)\s*\-\s*(\d+) hours a week$/
#     workload = (($1.to_f + $2.to_f) / 2).round
#     if duration.present?
#       effort = workload * duration
#     end
#   when /^(\d+) hours a week$/
#     workload = $1.to_i
#     if duration.present?
#       effort = workload * duration
#     end
#   when /^(\d+)\s*\-\s*(\d+) hours worth of material$/
#     effort = (($1.to_f + $2.to_f) / 2).round
#   when /^(\d+) hours worth of material$/
#     effort = $1.to_i
#   end
# end

# language = languages[ page_version.data[:language].try(:strip) ]

# published = ['en', 'es', 'pt'].include?(language) && url.present?

# provider_name = page_version.data[:provider] || page_version.data[:universities].try(:first)
# provider_name = provider_name.try(:[], :name) || page_version.data[:provider_name_2]

# video_url = nil
# if page_version.data[:trailer].present?
#   data_trailer = JSON.parse page_version.data[:trailer]
#   case data_trailer['type']
#   when 'coursera'
#     video_url = data_trailer['url']
#   when 'youtube'
#     video_slug = data_trailer['url'].split('/').last.gsub(/\?.*/, '')
#     video_url  = "https://youtu.be/#{video_slug}"
#   else
#     raise 'unknown video provider'
#   end
# end

# content = {
#   status:          page_version.data[:course_status].try(:strip),
#   course_name:     page_version.data[:course_name].try(:strip),
#   provider_name:   provider_name.try(:strip),
#   url:             url,
#   price:           price,
#   free_content:    free_content,
#   paid_content:    paid_content,
#   category:        page_version.data[:subject_name].try(:strip),
#   description:     ReverseMarkdown.convert(page_version.data[:course_overview] || ''),
#   syllabus:        ReverseMarkdown.convert(page_version.data[:syllabus] || ''),
#   duration:        duration,
#   workload:        workload,
#   video_url:       video_url,
#   effort:          effort,
#   rating:          page_version.data[:course_score].try(:strip),
#   language:        language,
#   subtitles:       [ language ],
#   audio:           [ language ], # Change Me... Really?!
#   published:       published,
#   aggregator_url:  page_version.data[:canonical_url].try(:strip),
#   stale:           false,
#   page_version_id: page_version.id
# }

# content[:slug] = [
#   I18n.transliterate( content[:provider_name] ).downcase,
#   I18n.transliterate( content[:course_name]   ).downcase,
#   Resource.digest( Zlib.crc32(content[:aggregator_url]) )
# ].join('-')
#   .gsub(/[\s\_\-]+/, '-')
#   .gsub(/[^0-9a-z\-]/i, '')
#   .gsub(/(^\-)|(\-$)/, '')

# manual_subjects = Marshal.load Zlib.inflate(File.read('db/seeds/class_central/subjects.dump'))

# if manual_data = manual_subjects[ content[:aggregator_url] ]
#   content[:category]  = manual_data[:category]
#   content[:tags]      = manual_data[:tags]
#   content[:published] = manual_data[:published]
#   content[:reviewed]  = true
# else
#   content[:category]  = nil
#   content[:tags]      = []
#   content[:published] = false
#   content[:reviewed]  = false
# end

# {
#   kind:      :course,
#   unique_id: Digest::SHA1.hexdigest(page_version.data[:canonical_url]),
#   content:   content,
#   relations: Hash.new
# }
