# -*- coding: utf-8 -*-
class ScheduleController < ApplicationController
  layout 'application'

  # 曜日配列
  $wdays = ["(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)"]

  # ----------------------------------------------
  # トップページ
  def index
    @view = "index"

    # view用
    @today = Time.now.strftime("%Y-%m-%d")

    # 表示年月設定
    # ?m=10&y=2015 なら2015年10月のデータを表示 nilや数字以外の場合はTime.nowを表示
    @view_month = params[:m].to_i
    @view_year  = params[:y].to_i
    if @view_month==0 && @view_year==0
      # クエリパラメータがない場合
      @view_month = Time.now.month if @view_month == 0
      @view_year  = Time.now.year  if @view_year  == 0
      @current_view = "#{@view_year}年#{@view_month}月〜#{@view_month+1}月"
      @schedule = Schedule.where('(month = ? or month = ?) and year = ?', Time.now.month, Time.now.month+1, Time.now.year)
    else
      #クエリパラメータを含む場合(片方だけの場合も)
      @view_month = Time.now.month if @view_month == 0
      @view_year  = Time.now.year  if @view_year  == 0
      @current_view = "#{@view_year}年#{@view_month}月"
      @schedule = Schedule.where(:month => @view_month, :year => @view_year)
    end
  end

  # ----------------------------------------------
  # 日付指定ビュー
  def day
    @view = "day"

    # GETパラメータから年月日を設定。データが欠けていたら今日の日付を設定
    unless params[:date].nil?
      day = params[:date]
    else
      day = Date.today.strftime("%Y-%m-%d")
    end

    # 設定した日付からDB検索
    @schedule = Schedule.where(:date => day)

    # 通常はindex.htmlを表示
    # 日付で検索した結果が0件だった場合、notfound.htmlを表示
    render :action => 'notfound' if @schedule.count == 0
    render :action => :index
  end

  # ----------------------------------------------
  # update
  def update
    ScheduleCrawler.execute
    render :action => :index
  end

  # ----------------------------------------------
  # twitter
  def twitter
    today = Date.today.strftime("%Y-%m-%d")
    @schedule = Schedule.where(:date => day)

    client = Twitter::REST::Client.new do |config|
      # developer
      config.consumer_key         = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret      = Rails.application.secrets.twitter_consumer_secret
      # user
      config.access_token         = Rails.application.secrets.token
      config.access_token_secret  = Rails.application.secrets.secret
    end

    # Twitter投稿
    client.update("#{Date.today.strftime("%Y年%m月%d日")}のスケジュール 出演: #{@schedule[0].band} http://narusushi.tk/day?date=#{today} #narusushi")
  end

  # ----------------------------------------------
  # カレンダービュー
  def calendar
    @schedule = Schedule.all
  end

  # ----------------------------------------------
  # カレンダーデータ取得用API
  def json
    @schedule = Schedule.all

    json_data = []
    @schedule.each do |s|
      next_str = ''
      next_str = '...' if s.band.length > 120
      json_data.push({
        #title: s.title,
        title: "#{s.band[0..120].gsub(/※.*/,'')}#{next_str}",
        start: s.date,
        description: s.band,
        url: "./ajax?date=#{s.date}",
        className: "open-modal calendar-content"
      })
    end

    render :json => json_data
  end

  # ----------------------------------------------
  # スケジュールがクリックされたら、そのスケジュールだけ取得してレンダリングする
  def ajax
    param = params[:date]
    @schedule = Schedule.where(:date => param).first
    render :partial => "modal_window"
  end

  def test
    render :text => "test"
  end

end
