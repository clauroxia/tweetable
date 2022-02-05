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

  describe "create path" do
    it "respond with http success status code" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      post api_test_create_path, params: { tweet: {body: "Test"}}
      expect(response).to have_http_status(201)
    end

    it "respond with the correct tweet" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      post api_test_create_path, params: { tweet: {body: "Test"}}
      actual_tweet = JSON.parse(response.body)
      expect(actual_tweet["id"]).to eql(Tweet.all.first.id)
    end

    it "returns http status not found" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      post api_test_create_path, params: { tweet: { body: "" }}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "update path" do
    it "respond with http success status code" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      tweet = Tweet.create(body: 'Test for update', user_id: user_to_test.id)
      patch api_test_update_path(tweet), params: { tweet: { body: "updated" }, id: tweet.id }
      expect(response).to have_http_status(200)
    end

    it "respond with the tweet already updated" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      tweet = Tweet.create(body: 'Test for update', user_id: user_to_test.id)
      patch api_test_update_path(tweet), params: { tweet: {body: "Updated"}, id: tweet.id }
      actual_tweet = JSON.parse(response.body)
      expect(actual_tweet["body"]).to eql("Updated")
    end

    it "returns http status not found" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      tweet = Tweet.create(body: 'Test for update', user_id: user_to_test.id)
      patch api_test_update_path(tweet), params: { tweet: { body: "" },  id: tweet.id}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "destroy path" do
    it "respond with http success status code" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      tweet = Tweet.create(body: 'Test', user_id: user_to_test.id)
      delete api_test_destroy_path, params: { id: tweet.id }
      expect(response).to have_http_status(:no_content)
    end

    it "respond with the tweet already destroyed" do
      user_to_test = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
      tweet = Tweet.create(body: 'Test for destroy', user_id: user_to_test.id)
      delete api_test_destroy_path, params: {  id: tweet.id }
      expect(response.body).to eql("")
    end

    it "returns http status not found" do
      delete api_test_destroy_path, params: { id: "fff"}
      expect(response).to have_http_status(:not_found)
    end
  end
end