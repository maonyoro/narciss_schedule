# -*- coding: utf-8 -*-
class ScheduleController < ApplicationController
  layout 'application'

  # トップページ 全スケジュール表示
  def index
    @schedule = Schedule.all
  end

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

  # スケジュールがクリックされたら、そのスケジュールだけ取得してレンダリングする
  def ajax
    param = params[:date]
    @schedule = Schedule.where(:date => param).first
    render :partial => "modal_window"
  end

end
