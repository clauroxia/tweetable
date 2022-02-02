class TweetController < ApplicationController
  def index
    @tweets = Tweet.all
  end
end
