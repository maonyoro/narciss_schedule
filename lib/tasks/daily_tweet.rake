# encoding: utf-8
namespace :daily_tweet do
  desc "narusushichanによるツイート"
  task :execute => :environment do
    TweetBatch.execute
  end
end
