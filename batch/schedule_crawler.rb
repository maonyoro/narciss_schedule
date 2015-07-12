# -*- coding: utf-8 -*-
class ScheduleCrawler < ApplicationController
  class CrawlError < StandardError; end

  URL = 'http://www.zmf.co.jp/schedule/'

  class << self
    def execute
      # メイン処理
      #logger.info "crawl start."

      get_detail
    end

    def get_detail
      html = open(URL) { |f| f.read }
      doc  = Nokogiri::HTML.parse(html, nil, 'shift-jis')
  
      doc.xpath('//tr[@class="month"]').each do |day|
        @schedule = Schedule.new
        @schedule.date     = day.css('a').attribute('name').value
        @schedule.presents = day.css('div[@class="spresents"]').inner_text
        @schedule.title    = day.css('div[@class="stitle"]').inner_text
        @schedule.open     = day.css('div[@class="sopen"]').inner_text
        @schedule.band     = day.css('div[@class="sband"]').inner_text
        @schedule.save
      end
    end

  end
end

ScheduleCrawler.execute
