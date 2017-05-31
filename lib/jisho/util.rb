module Jisho
  module Util
    extend self

    def format_resp(resp)
      formatted_resp = []
      JSON.parse(resp)['data'].select { |m| m['is_common'] }.take(10).each do |r|
        formatted_resp.push({
          kanji: r["japanese"].first["word"],
          hiragana: r["japanese"].first["reading"],
          english: r["senses"].first["english_definitions"].join(', ')
        })
      end
      formatted_resp
    end
  end
end
