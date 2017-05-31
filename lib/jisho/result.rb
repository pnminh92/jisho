module Jisho
  class Result
    CONSOLE_WIDTH = IO.console.winsize[1]
    HEADERS = %w(kanji hiragana english)

    class << self
      def display(word, response)
        print header(word)
        print body(response)
      end

      private

      def header(word)
        output = "\n#{seperator}\nsearching word: #{word}\n#{seperator}\n"
        HEADERS.each_with_index do |header, index|
          output += header
          break if index == 2
          output += "#{whitespace(header)}| "
        end
        output += "\n#{seperator}"
      end

      def body(resp)
        output = ""
        Jisho::Util.format_resp(resp).each do |r|
          output += "\n"
          HEADERS.each_with_index do |header, i|
            word = r[header.to_sym] || ''
            output += word
            break if i == 2
            output += "#{whitespace(word)}| "
          end
        end
        output
      end

      def seperator
        output = ""
        CONSOLE_WIDTH.times.each { |i| output += "-" }
        output
      end

      def whitespace(word)
        output = ""
        used_width = word =~ /\p{Han}|\p{Hiragana}|\p{Katakana}/ ? word.length * 2 : word.length
        (CONSOLE_WIDTH / 3 - used_width).times.each { |i| output += " " }
        output
      end
    end
  end
end
