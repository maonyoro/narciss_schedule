# encoding: utf-8
namespace :batch do
  desc "zmf.co.jp/scheduleからデータを取ってきてパースしてDB格納"
  $rails_rake_task = true

  task :execute => :environment do
    ScheduleCrawler.execute
  end
end
