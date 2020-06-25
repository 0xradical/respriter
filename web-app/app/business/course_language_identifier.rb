class CourseLanguageIdentifier

  def identify(course)
    classifier_result = classifier_detect(course)
    audio_locales = audio_detect(course)
    compare_languages(classifier_result, audio_locales)
  end

  def identify!(course)
    locale, status = identify(course)
    update_course!(course, locale, status,)
  end

  def override!(course, locale)
    update_course!(course, locale, 'manually_overriden')
  end

  protected
  def classifier_detect(course)
    detected = CLD.detect_language(course.description)
    {
      reliable: detected[:reliable],
      locale: Locale.from_string(detected[:code])
    }
  end

  def audio_detect(course)
    audio_list = course.audio || []
    audio_list.map { |audio_locale| Locale.from_string(audio_locale) }
  end

  def compare_languages(classifier_result, audio_locales)
    num_audio = audio_locales.map(&:lang).uniq.size
    locale_matches = best_match(classifier_result[:locale], audio_locales)

    return case
    when num_audio == 0
      [nil, 'empty_audio']  
    when num_audio > 1
      [nil, 'multiple_languages']
    when locale_matches.size > 1
      [nil, 'multiple_countries']
    when !classifier_result[:reliable]
      [nil, 'not_identifiable']
    when locale_matches.empty?
      [nil, 'mismatch']
    else
      [locale_matches.first, 'ok']
    end
  end

  def best_match(classifier_locale, audio_locales)
    same_lang = audio_locales.select { |locale| classifier_locale.lang == locale.lang }
    with_country = same_lang.select { |locale| locale.country.present? }
    with_country.present? ? with_country : same_lang.uniq
  end

  def update_course!(course, locale, status)
    if course.locale_status == 'manually_overriden' && status != 'manually_overriden'
      return false
    end

    attributes = { locale_status: status }
    attributes.merge!({ locale: locale.to_pg }) if locale
    course.update(attributes)
  end
end
