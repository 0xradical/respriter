# frozen_string_literal: true

module JapaneseHelper
  require 'mecab_standalone'
  require 'nkf'

  def contains_kanji?(str)
    !!(str =~ /\p{Han}/)
  end

  def convert_to_kana(str) 
    NKF.nkf('-h1 -w', contains_kanji?(str) ? (MecabStandalone.reading(str.delete("()\"'")).delete!("\n") || str ) : str )
  end

  def gojuon_index(kana_str)
    case kana_str[0]
    when 'ぁ'..'お'
      'あ行'
    when 'か'..'ご'
      'か行'
    when 'さ'..'ぞ'
      'さ行'
    when 'た'..'ど'
      'た行'
    when 'な'..'の'
      'な行'
    when 'は'..'ぽ'
      'は行'
    when 'ま'..'も'
      'ま行'
    when 'ゃ'..'よ'
      'や行'
    when 'ら'..'ろ'
      'ら行'
    when 'ゎ'..'を'
      'わ行'
    else # must be roman alphabet
      kana_str[0].upcase
    end
  end
end

