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
        while i < e.size do
          if e.values[i].instance_of?(Array)
            result += e.keys[i] +":  "+ e.values[i].join(",") + "\n\n"
          elsif e.values[i].instance_of?(Integer) || e.values[i].instance_of?(Hash) || e.values[i].instance_of?(Float)
            result += e.keys[i] +":  "+ e.values[i].to_s + "\n\n"
          elsif e.values[i].nil? || e == 0
            result += e.keys[i] + "\n\n"
          else
            result += e.keys[i] +":  "+ e.values[i] + "\n\n"
          end
          i += 1
        end
      }
      reply.text = result
      reply.send_with(bot)
    end
  end
end
