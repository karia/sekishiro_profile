#!/usr/bin/env ruby

require 'faraday'
require 'twitter'

client = Twitter::REST::Client.new do |conf|
  conf.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  conf.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  conf.access_token = ENV['TWITTER_ACCESS_TOKEN']
  conf.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

location_now = client.user("Mico_HNST").location.to_s.chomp
puts Time.now.to_s + " の位置情報:" + location_now

# 前回の現在地を取得
location_file = "/var/tmp/tmp_location_mico.txt"
location_list = File.open(location_file).readlines
location_old = location_list.first.to_s.chomp

if location_now == location_old
  puts "前回と同じです"
  exit
else
  puts "前回と違います"
end

# Discordに投げる
bottext = '{ "content" : "ミコちゃんの現在地\n「' + location_now + '」" }'
puts bottext

conn = Faraday.new
conn.post do |req|
  req.url ENV['WEBHOOK_URL']
  req.headers['Content-Type'] = 'application/json'
  req.body = bottext
end

puts "discordへ投稿しました"

# ファイルに保存
File.open(location_file, "w") do |f|
  f.puts(location_now)
end

puts "ファイルに保存しました"

