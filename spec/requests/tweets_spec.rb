require 'rails_helper'
describe 'Genres', type: :request do
  it 'index path respond with http success status code' do
    get '/api/genres'
    expect(response.status).to eq(200)
  end
end