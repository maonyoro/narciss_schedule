# -*- coding: utf-8 -*-
require 'nkf'
require 'net/http'

class ScheduleCrawler < ApplicationController
  class CrawlError < StandardError; end

  $uri  = 'zmf.co.jp'
  $path = '/schedule/index.html'
  #URL = 'http://www.zmf.co.jp/schedule/'
  #URL = 'batch/201507.html'

  class << self

    def execute
      # メイン処理
      #logger.info "crawl start."

      get_detail
    end

    # HTML取得しパース、DBへ格納するメソッド
    def get_detail
      # URLにアクセスし、得られたHTMLからパース用オブジェクトdocを生成
      if ENV["HTTP_PROXY"].nil?
        html = open("http://"+$uri+$path).read
      else
        proxy = Net::HTTP::Proxy(ENV["HTTP_PROXY"])
        http  = proxy.new($uri)
        html  = http.get($path).body
      end
      doc  = Nokogiri::HTML.parse(html, nil, 'CP932')

      # docをパースして、スケジュールの内容をwork[]にpushする
      work = []
      doc.xpath('//tr[@class="month"]').each do |day|
        date     = day.css('a').attribute('name').value
        month    = date[0,2].to_i
        presents = day.css('div[@class="spresents"]').inner_text.gsub(/[　\n]/,"")
        title    = day.css('div[@class="stitle"]').inner_text.gsub(/[　\n]/,"")
        open     = day.css('div[@class="sopen"]').inner_text.gsub(/[　\n]/,"")
        link     = NKF.nkf("-w -X", day.css('div[@class="sband"]').inner_text).match(/http.*/).to_s.gsub(/ .*/,"")
        band     = NKF.nkf("-w -X", day.css('div[@class="sband"]').inner_html).gsub(link,"").gsub('<br>', "/").gsub(/[　\n]/,"").gsub('/', ' / ').gsub('  /  ', ' / ').gsub(/ *$/,"").gsub(/\/$/,"") #nkfで半角カナを全角に
        band = band+' <a href="'+link+'" target="_blank">'+link+'</a>' unless link.empty? #リンクを丁寧に設定してみる
        work.push({:date => date, :month => month, :presents => presents, :title => title, :open => open, :band => band})
      end

      # HTMLから年を取得 うまく取得できなかったらTimeクラスから取得する
      /20../ =~ doc.xpath('//th[@class="month"]').inner_text
      year = $&
      if year.nil?
        year = Time.now.year.to_s
      end

      # データをINSERT/UPDATEする
      work.each do |w|
        current_date = "#{year}-#{w[:date]}".clone.insert(7, "-") # "2015-07-01"
        record = Schedule.where(:date => current_date)
        if record.empty?
          # 新規追加
          @schedule = Schedule.new
          @schedule.date     = current_date
          @schedule.month    = w[:month]
          @schedule.year     = year.to_i
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
