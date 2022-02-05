require "faker"
require 'open-uri'

User.destroy_all
Tweet.destroy_all
Like.destroy_all

puts "Creating admin"
admin = User.new(
  username: "@admin",
  name: "admin",
  email: "admin@mail.com",
  password: "supersecret",
  role: 1
)
admin.avatar.attach(io: File.open("app/assets/images/image_profile_default.png"), filename: "admin.png")
puts "Admin not created. Errors: #{admin.errors.full_messages}" unless admin.save


puts "Seeding users"
i = 1
4.times do |member|
  member = User.new
  member.username = "@visitor#{i}"
  member.name = Faker::Name.name
  member.email = "visitor#{i}@mail.com"
  member.password = "letmein"
  member.avatar.attach(io: URI.open(Faker::Avatar.unique.image(size: "50x50")), filename: "visitor#{i}.jpg")
  puts "Member not created. Errors: #{member.errors.full_messages}" unless member.save
  i +=1
end

puts "Seeding tweets"
users = User.all
users.each do |user|
  rand(1..2).times do
    new_tweet = Tweet.new
    new_tweet.user = user
    new_tweet.body = Faker::Lorem.paragraph(sentence_count: rand(1..3))
    puts "Tweet not created. Errors: #{new_tweet.errors.full_messages}" unless new_tweet.save
  end
end

puts "Seeding replies"
tweets = Tweet.all
users = User.all
users.each do |user|
  tweets.each do |tweet|
    rand(0..2).times do
      new_reply = Tweet.new(parent_id: tweet.id)
      new_reply.body = Faker::Lorem.paragraph(sentence_count: rand(1..3))
      new_reply.user = user
      puts "Reply not created. Errors: #{new_reply.errors.full_messages}" unless new_reply.save
    end
  end
end

puts "Seeding likes"
users = User.all
users.each do |user|
  tweets = Tweet.all
  12.times do
    liked = tweets[rand(0..tweets.length - 1)]
    new_like = Like.new
    new_like.user = user
    new_like.tweet = liked
    new_like.save unless Like.find_by(user_id: user.id, tweet_id: liked.id)
  end
end
