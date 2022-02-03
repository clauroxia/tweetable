class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
    @tweet = Tweet.new
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user

    if @tweet.save
      redirect_to root_path, notice: "Tweet created", status: :created
    else
      render root_path, notice: "Tweet could not be created", status: :unprocessable_entity
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update(tweet_params)
      redirect_to root_path, notice: "Tweet successfully updated"
    else
      render :edit, notice: "Tweet could not be updated", status: :unprocessable_entity
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy

    if params["tweet_id"]
      redirect_to tweet_path(tweet), notice: "Tweet deleted", status: :see_other
    else
      redirect_to root_path, notice: "Tweet deleted", status: :see_other
    end
  end

  # Custom methods

  def like; end

  def unlike; end

  private

  def tweet_params
    params.require(:tweet).permit(:body)
  end
end
