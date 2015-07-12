# -*- coding: utf-8 -*-
require 'date'

class ScheduleCrawler < ApplicationController
  class CrawlError < StandardError; end

  #URL = 'http://www.zmf.co.jp/schedule/'
  URL = 'batch/201507.html'

  class << self

    def execute
      # メイン処理
      #logger.info "crawl start."

      get_detail
    end

    # HTML取得しパース、DBへ格納するメソッド
    def get_detail
      # URLにアクセスし、得られたHTMLからパース用オブジェクトdocを生成
      html = open(URL).read
      doc  = Nokogiri::HTML.parse(html, nil, 'CP932')
  
      # docをパースして、スケジュールの内容をwork[]にpushする
      work = []
      doc.xpath('//tr[@class="month"]').each do |day|
        date     = day.css('a').attribute('name').value
        presents = day.css('div[@class="spresents"]').inner_text.gsub(/[　\n]/,"")
        title    = day.css('div[@class="stitle"]').inner_text.gsub(/[　\n]/,"")
        open     = day.css('div[@class="sopen"]').inner_text.gsub(/[　\n]/,"")
        band     = day.css('div[@class="sband"]').inner_text.gsub(/[　\n]/,"")
        work.push({:date => date, :presents => presents, :title => title, :open => open, :band => band})
      end

      # HTMLから年を取得 うまく取得できなかったらDateクラスから取得する
      /20../ =~ doc.xpath('//th[@class="month"]').inner_text
      year = $&
      if year.nil?
        year = Date.today.year
      end

      # データをINSERT/UPDATEする
      work.each do |w|
        record = Schedule.where(:date => "#{year}#{w[:date]}") # "20150701"のようになる
        if record.empty?
          # 新規追加
          @schedule = Schedule.new
          @schedule.date     = "#{year}#{w[:date]}"
          @schedule.presents = w[:presents]
          @schedule.title    = w[:title]
          @schedule.open     = w[:open]
          @schedule.band     = w[:band]
          @schedule.save
        else
          # 既に同じdateのデータが存在する場合は更新する
          record.update_all(
            :presents => w[:presents],
            :title    => w[:title],
            :open     => w[:open],
            :band     => w[:band]
          )
        end
      end
    end

  end
end

ScheduleCrawler.execute
