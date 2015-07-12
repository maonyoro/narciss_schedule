# -*- coding: utf-8 -*-
class ScheduleController < ApplicationController
  layout 'application'

  def index
    @schedule = Schedule.all
  end

end
