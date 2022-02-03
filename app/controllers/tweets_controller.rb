class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show edit update destroy like unlike]

  def index
    @tweets = Tweet.all
    @tweet = Tweet.new
  end

  def show
    # @tweet = Tweet.find(params[:id])
    @new_tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params) 
    if params["tweet_id"]
      @reply = @tweet
      @reply.user = current_user
      @parent_tweet = Tweet.find(params["tweet_id"])
      @reply.parent_id = @parent_tweet.id
      if @reply.save
        redirect_to tweet_path(params["tweet_id"]), notice: "Reply created"
      else
        render tweet_path(params["tweet_id"]), notice: "Reply could not be created", status: :unprocessable_entity
      end
    else
      @tweet.user = current_user
      if @tweet.save
        redirect_to root_path, notice: "Tweet created", status: :created
      else
        render root_path, notice: "Tweet could not be created", status: :unprocessable_entity
      end
    end
  end

  def edit
    # @tweet = Tweet.find(params[:id])
    @parent_tweet = Tweet.find(params["tweet_id"]) if params["tweet_id"]
  end

  def update
    # @tweet = Tweet.find(params[:id])
    if params["tweet_id"]
      if @tweet.update(tweet_params)
        redirect_to tweet_path(params["tweet_id"]), notice: "Tweet successfully updated"
      else
        render :edit, notice: "Tweet could not be updated", status: :unprocessable_entity
      end
    elsif !params["tweet_id"]
      if @tweet.update(tweet_params)
        redirect_to root_path, notice: "Tweet successfully updated"
      else
        render :edit, notice: "Tweet could not be updated", status: :unprocessable_entity
      end
    end
  end

  def destroy
    # tweet = Tweet.find(params[:id])
    @tweet.destroy

    if params["tweet_id"]
      redirect_to tweet_path(params["tweet_id"]), notice: "Tweet deleted", status: :see_other
    else
      redirect_to root_path, notice: "Tweet deleted", status: :see_other
    end
  end

  # Custom methods

  def like
    like = Like.new(user_id: current_user.id, tweet_id: @tweet.id)
    # redirect_to root_path if like.save
    redirect_to root_path if like.save
  end

  def unlike
    like_to_destroy = Like.find_by(user_id: current_user.id, tweet_id: @tweet.id)
    redirect_to root_path if like_to_destroy.destroy
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:body)
  end
end
