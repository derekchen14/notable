namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_notes
  end
end

def make_users
  admin = User.create!(username: "Derek Chen",
                       email:    "admin@notable.im",
                       password: "notable14",
                       password_confirmation: "notable14")
  admin.toggle!(:admin)
  14.times do |n|
    username  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(username: username,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_notes
  users = User.all(limit: 6)
  5.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.notes.create!(content: content) }
  end
end