# OLD, DEPRECATED CODE. WON'T WORK.
# # TODO: Handle stale courses
# raise PostProcessor::UnableToProcess unless page_version.data.present?

# data = page_version.data

# categories = [ data[:category_name], data[:subcategory_name] ].compact.uniq

# begin
# categories += data[:categories].compact.map{ |c| c[:name] }
# categories.compact.uniq
# rescue
# end

# language = 'pt-BR'
# url = "https://www.eduk.com.br/cursos/#{data[:slug]}"

# content = {
#   url:             url,
#   tags:            categories,
#   language:        language,
#   audio:           language,
#   subtitles:       [],
#   stale:           false,
#   video_url:       data[:preview_video_url],
#   price:           29.90, # TODO: Change it
#   price_details:   'preço mensal da assinatura anual',
#   currency:        'BRL',
#   status:          data[:status],
#   category:        categories.first,
#   duration:        nil,
#   workload:        nil,
#   effort:          nil,
#   syllabus:        nil,
#   description:     data[:description],
#   course_name:     data[:title],
#   paid_content:    !data[:free],
#   free_content:    data[:free],
#   provider_name:   'eduK',
#   reviewed:        false,
#   published:       true,
#   rating:          data[:rating],
#   extra:           { course_id: data[:id] },
#   page_version_id: page_version.id
# }

# content[:slug] = [
#   'eduk',
#   I18n.transliterate(content[:course_name]).downcase,
#   Resource.digest(Zlib.crc32(content[:url]))
# ].join('-')
#   .gsub(/[\s\_\-]+/, '-')
#   .gsub(/[^0-9a-z\-]/i, '')
#   .gsub(/(^\-)|(\-$)/, '')

# {
#   kind:      :course,
#   unique_id: Digest::SHA1.hexdigest(content[:extra][:course_id].to_s),
#   content:   content,
#   relations: Hash.new
# }
