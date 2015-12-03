# -*- coding: utf-8 -*-

class TweetBatch < ApplicationController

  class << self

    def execute
      today = Date.today.strftime("%Y-%m-%d")
      @schedule = Schedule.where(:date => today)

      client = Twitter::REST::Client.new do |config|
        # developer
        config.consumer_key         = Rails.application.secrets.twitter_consumer_key
        config.consumer_secret      = Rails.application.secrets.twitter_consumer_secret
        # user
        config.access_token         = Rails.application.secrets.token
        config.access_token_secret  = Rails.application.secrets.secret
      end

      # Twitter投稿
      text="浦和ナルシス #{Date.today.strftime("%Y年%m月%d日")}のスケジュール\n#{@schedule[0].band.force_encoding("utf-8").gsub(' / ','/')}"
      if text.length > 95
        text.slice!(94, text.length)
        text.<<("…")
      end
      text.<<("\nhttp://narusushi.tk/day?date=#{today}")
      client.update(text)
    end

  end
end
