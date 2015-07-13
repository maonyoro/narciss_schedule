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
        url: "/"
      })
    end

    render :json => json_data
  end

end
