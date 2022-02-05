require 'rails_helper'
describe 'Tweets', type: :request do
  it 'index path respond with http success status code' do
    get '/api/tweets'
    expect(response).to have_http_status(:ok)
  end

  it 'index path returns a json with all tweets' do
    user = User.create( username: "@probino", name: "probino", email: "probino@mail.com", password: "letmein" )
    Tweet.create(body: 'Test', user_id: user.id)
    get '/api/tweets'
    tweets = JSON.parse(response.body)
    expect(tweets.size).to eq 1
  end
end