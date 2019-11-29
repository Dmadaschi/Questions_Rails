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
      show_spinner('ceating default subjects') { `rails dev:add_subjects` }
      show_spinner('ceating default qestions and answares') { `rails dev:add_questions_answares` }
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
  task add_questions_answares: :environment do
    Subject.all.each do |subject|
      rand(2..6).times do |_i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        elect_true_answer(answers_array)

        Question.create!(params[:question])
      end
    end
  end
  def create_answer_params(option = false)
    { description: Faker::Lorem.sentence, correct: option }
  end

  def add_answers(answers_array)
    rand(2..5).times do |_j|
      answers_array.push(
        create_answer_params
      )
    end
  end

  def elect_true_answer(answers_array)
    index = rand(answers_array.size)
    answers_array[index] = create_answer_params(true)
  end

  def create_question_params(subject = Subject.all.sample)
    { question: {
      description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
      subject: subject,
      answers_attributes: []
    } }
  end

  def show_spinner(msg_start, _msg_end = 'Done')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success { '(#(msg_end))' }
  end
end
