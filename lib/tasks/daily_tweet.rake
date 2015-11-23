# encoding: utf-8
namespace :daily_tweet do
  desc "narusushichanによるツイート"
  TweetBatch.execute
end
