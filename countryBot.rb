require 'telegram_bot'
require "open-uri"
require 'json'

token ='794487993:AAHdGN4he41TElP074Z5OdF2s97mzuglUhg'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

    message.reply do |reply|
      result = ""
      i = 0
    case command
    when /start/i
      reply.text = "I know all the Countries!"
    else
      begin
        resString = JSON.parse(URI.parse("https://restcountries.eu/rest/v2/name/#{message.text}").read)
      rescue StandardError => e
        reply.text = "The country #{message.text} couldn't be found"
        reply.send_with(bot)
        break
      end
      resString.map { |e|
        result = ""
        e.each do |q,i|
          unless q == "alpha2Code" || q == "alpha3Code" || q == "latlng" || q == "gini"
            puts q
            if i.instance_of?(Array)
              result += q +":  "+ i.join(",") + "\n\n"
            elsif i.instance_of?(Integer) || i.instance_of?(Hash) || i.instance_of?(Float)
              result += q +":  "+ i.to_s + "\n\n"
            elsif i.nil? || e == 0
              result += q + "\n\n"
            else
              result += q +":  "+ i + "\n\n"
            end
          end
        end
        reply.text = result
        reply.send_with(bot)
      }
    end
    reply.send_with(bot)
  end
end
