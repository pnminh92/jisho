require "jisho/version"
require "net/http"
require "json"

module Jisho
  extend self

  JISHO_API_URL = "http://jisho.org/api/v1"
  CONSOLE_WIDTH = IO.console.winsize[1]
  HEADERS = %w(kanji hiragana english)

  def search(words)
    path = "/search/words"
    uri = URI(JISHO_API_URL)
    uri.path << path
    uri.query = URI.encode_www_form(keyword: words)
    response = Net::HTTP.get_response(uri)
    results(words, response.body)
  end

  def results(words, body)
    print table_header(words)
    print table_body(body)
  end

  def table_header(words)
    output = "#{words}\n#{seperator}\n"
    HEADERS.each_with_index do |header, index|
      output += header.capitalize
      break if index == 2
      output += "#{whitespace}| "
    end
    output += "\n#{seperator}"
  end

  def seperator
    output = ""
    CONSOLE_WIDTH.times.each { |i| output += "-" }
    output
  end

  def whitespace
    output = ""
    (CONSOLE_WIDTH / 3).times.each { |i| output += " " }
    output
  end

  def table_body(results)
    output = ""
    results = format_results(results)
    results.each do |r|
      output += "\n"
      HEADERS.each_with_index do |header, i|
        output += r[header.to_sym]
        break if i == 2
        output += "#{whitespace}| "
      end
    end
    output
  end

  def format_results(body)
    formatted = []
    parsed_body = JSON.parse(body)['data']
    results = parsed_body.select { |m| m['is_common'] }.take(10)
    results.each do |r|
      formatted.push({
        kanji: r["japanese"].first["word"],
        hiragana: r["japanese"].first["reading"],
        english: r["senses"].first["english_definitions"].join(', ')
      })
    end
    formatted
  end
end
