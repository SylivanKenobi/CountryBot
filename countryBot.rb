require 'telegram_bot'
require "open-uri"
require 'json'

token ='794487993:AAHdGN4he41TElP074Z5OdF2s97mzuglUhg'
re1='.*?'	# Non-greedy match on filler
re2='(\\d+)'	# Integer Number 1
re=(re1+re2)
m=Regexp.new(re,Regexp::IGNORECASE);

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

    message.reply do |reply|
      path = Dir.pwd
    case command
    when /start/i
      reply.text = "I am your Trainer"
    when /p/i      
      reply.text = m.match(message.text)[1] + " Pushups have benn added";
      puts m.match(message.text)[1].to_i + 1
      File.write(path + '/pushup.txt', File.read(path + '/pushup.txt').to_i + m.match(message.text)[1].to_i)
    when /c/i
      reply.text = m.match(message.text)[1] + " Crunches have benn added"
      File.write(path + '/crouch.txt', File.read(path + '/crouch.txt').to_i + m.match(message.text)[1].to_i)
    when /stats/i
      reply.text = File.read(path + '/crouch.txt') + " Crouches " + File.read(path + '/pushup.txt') + " Pushups"
    end
    reply.send_with(bot)
  end
end
