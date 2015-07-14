# -*- coding: utf-8 -*-
class ScheduleController < ApplicationController
  layout 'application'

  def index
    @schedule = Schedule.all
  end

  def json
    @schedule = Schedule.all

    json_data = []
    @schedule.each do |s|
      json_data.push({
        title: s.title,
        start: s.date,
        description: s.band,
        url: "./ajax?date=#{s.date}",
        className: "open-modal"
      })
    end

    render :json => json_data
  end

  def ajax
    param = params[:date]
    @schedule = Schedule.where(:date => param).first
    render :text => "#{param} #{@schedule.title} #{@schedule.band}"
  end

end
