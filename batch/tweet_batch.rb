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
      client.update("浦和ナルシス #{Date.today.strftime("%Y年%m月%d日")}のスケジュール 出演: #{@schedule[0].band} http://narusushi.tk/day?date=#{today} #narusushi")
    end

  end
end
