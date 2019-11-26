# frozen_string_literal: true

class AdminsBackoffice::QuestionsController < AdminsBackofficeController
  before_action :set_question, only: %i[update edit destroy]
  before_action :find_subjects, only: %i[edit new]
  def index
    @questions = Question.includes(:subject).all.order(:subject).page(params[:page])
  end

  def edit; end

  def update
    # update total
    if @question.update(params_subject)
      redirect_to admins_backoffice_questions_path, notice: 'successful update'
    else
      render :edit
    end
  end

  def new
    @question = Question.new
  end

  def create
    # create
    @question = Question.new(params_subject)

    if @question.save
      redirect_to admins_backoffice_questions_path, notice: 'successful create'
    else
      render :new
    end
  end

  def destroy
    # delete
    if @question.destroy
      redirect_to admins_backoffice_questions_path, notice: 'successful delete'
    else
      render :index
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def params_subject
    params.require(:question).permit(:description)
  end

  def find_subjects
    @subjects = Subject.all
  end
end
