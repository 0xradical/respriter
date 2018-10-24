class HttpAcceptLanguageParser

  ACCEPT_LANGUAGE_REGEX = /((?:[a-zA-Z-]{2,5},?)+;q=[0-9.]{1,3})/

  def self.parse(accept_language_string)
    raise MissingHttpAcceptLanguageHeader, 'missing http accept language header' if accept_language_string.blank?
    matches = accept_language_string.scan(ACCEPT_LANGUAGE_REGEX)
    matches.flatten!
    matches.map { |e| e.split(";q=")[0] }.map { |e| e.split(',') }.flatten
  end

  class MissingHttpAcceptLanguageHeader < RuntimeError; end;

end
