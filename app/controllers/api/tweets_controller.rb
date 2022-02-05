module Api
  class TweetsController < Api::ApiController
    before_action :set_tweet, only: %i[show update destroy like unlike]

    def index
      @tweets = Tweet.all
      render json: @tweets, status: :ok
    end

    def show
      # @tweet = Tweet.find(params[:id])
      render json: @tweet, status: :ok
    end

    def create
      @tweet = Tweet.new(tweet_params)
      @tweet.user_id = current_user.id
      @tweet.parent_id = params["parent_id"] if params["parent_id"]
      
      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      # @tweet = Tweet.find(params[:id])
      authorize(@tweet)
      if @tweet.update(tweet_params)
        render json: @tweet, status: :ok
      else
        render json: { errors: @tweet.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      # tweet = Tweet.find(params[:id])
      authorize(@tweet)
      @tweet.destroy
      head :no_content
      
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

    def replies
      @parent = Tweet.find(params["tweet_id"])
      render json: @parent.replies, status: :ok
    end

    private

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:body)
    end
  end
end
