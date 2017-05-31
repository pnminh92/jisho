require "net/http"
require "json"
require "io/console"
require "jisho/version"
require "jisho/util"
require "jisho/result"

module Jisho
  extend self

  JISHO_API_URL = "http://jisho.org/api/v1"

  def search(words)
    path = "/search/words"
    uri = URI(JISHO_API_URL)
    uri.path << path
    uri.query = URI.encode_www_form(keyword: words)
    response = Net::HTTP.get_response(uri)
    if Net::HTTPSuccess === response
      Jisho::Result.display(words, response.body)
    else
      raise "Could not connect to jisho.org API"
    end
  end
end
