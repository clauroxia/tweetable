require 'rails_helper'
describe 'Tweets', type: :request do
  describe "index path" do
    it 'respond with http success status code' do
      get '/api/tweets'
      expect(response).to have_http_status(:ok)
    end

    it 'returns a json with all tweets' do
      user = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      Tweet.create(body: 'Test', user_id: user.id)
      get '/api/tweets'
      tweets = JSON.parse(response.body)
      expect(tweets.size).to eq 1
    end
  end

  describe "show path" do
    it "respond with http success status code" do
      user = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      tweet = Tweet.create(body: 'Test', user_id: user.id)
      get api_tweet_path(tweet)
      expect(response).to have_http_status(:ok)
    end

    it "respond with the correct tweet" do
      user = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      tweet = Tweet.create(body: 'Test', user_id: user.id)
      get api_tweet_path(tweet)
      actual_tweet = JSON.parse(response.body)
      expect(actual_tweet["id"]).to eql(tweet.id)
    end

    it "returns http status not found" do
      get "/api/tweets/:id", params: { id: "xxx" }
      expect(response).to have_http_status(:not_found)
    end
  end
end