# frozen_string_literal: true

namespace :dev do
  DEFAULT_PASSWORD = 123_456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')
  desc 'Configura ambiente de desenvolvinemro'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('erasing database') { `rails db:drop` }
      show_spinner('creating database') { `rails db:create` }
      show_spinner('migrating database') { `rails db:migrate` }
      show_spinner('creating default admin') { `rails dev:add_default_admin` }
      show_spinner('creating extra admins') { `rails dev:add_aditional_admins` }
      show_spinner('creating default user') { `rails dev:add_default_user` }
      show_spinner('deating default subjects') { `rails dev:add_subjects` }
      show_spinner('deating default qestions and answares') { `rails dev:add_questions` }
    else
      puts 'You are not in development envoirement'
    end
  end
  desc 'Add default admin'
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end
  desc 'add aditional admins'
  task add_aditional_admins: :environment do
    10.times do |_i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc 'add default user'
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  desc 'Add default Subjects'
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc 'Add default Questions and Answares'
  task add_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |_i|
        Question.create!(
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject
        )
      end
    end
  end

  def show_spinner(msg_start, _msg_end = 'Done')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success { '(#(msg_end))' }
  end
end
