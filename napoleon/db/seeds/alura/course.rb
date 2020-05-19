# OLD, DEPRECATED CODE. WON'T WORK
# raise PostProcessor::UnableToProcess unless page_version.json_ld.present?

# document = Nokogiri::HTML(page_version.payload)
# breadcrumb_json_ld, course_json_ld = page_version.json_ld

# category = breadcrumb_json_ld[:itemListElement][1][:item][:name].gsub(/^cursos? online d.\s+/i, '')
# language = 'pt-BR'

# prices = document.css('.planosPagamento-planos-plano').map{ |node| node.attribute('data-payment-plan-price').text.gsub('.', '').to_i }

# content = {
#   url:             breadcrumb_json_ld[:itemListElement].last[:item][:@id],
#   tags:            [ category ].compact,
#   language:        language,
#   audio:           language,
#   subtitles:       [ language ],
#   stale:           false,
#   video_url:       nil,
#   price:           (prices.min/12),
#   price_details:   'preço mensal da assinatura anual',
#   currency:        'BRL',
#   status:          nil,
#   category:        category,
#   duration:        nil,
#   workload:        nil,
#   syllabus:        nil,
#   description:     course_json_ld[:description],
#   course_name:     course_json_ld[:name],
#   paid_content:    true,
#   free_content:    false,
#   provider_name:   'Alura',
#   reviewed:        false,
#   published:       true,
#   effort:          document.css('.curso-detalhes-info-item-time').text.strip.to_f,
#   rating:          nil,
#   extra:           [ prices: prices ],
#   page_version_id: page_version.id
# }

# content[:slug] = [
#   'alura',
#   I18n.transliterate(content[:course_name]).downcase,
#   Resource.digest(Zlib.crc32(content[:url]))
# ].join('-')
#   .gsub(/[\s\_\-]+/, '-')
#   .gsub(/[^0-9a-z\-]/i, '')
#   .gsub(/(^\-)|(\-$)/, '')

# {
#   kind:      :course,
#   unique_id: Digest::SHA1.hexdigest(content[:url]),
#   content:   content,
#   relations: Hash.new
# }
