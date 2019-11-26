# frozen_string_literal: true

class AdminsBackoffice::SubjectsController < AdminsBackofficeController
  before_action :set_subject, only: %i[update edit destroy]

  def index
    @subjects = Subject.all.order(:description).page(params[:page])
  end

  def edit; end

  def update
    # update total
    if @subject.update(params_subject)
      redirect_to admins_backoffice_subjects_path, notice: 'successful update'
    else
      render :edit
    end
  end

  def new
    @subject = Subject.new
  end

  def create
    # create
    @subject = Subject.new(params_subject)

    if @subject.save
      redirect_to admins_backoffice_subjects_path, notice: 'successful create'
    else
      render :new
    end
  end

  def destroy
    # delete
    if @subject.destroy
      redirect_to admins_backoffice_subjects_path, notice: 'successful delete'
    else
      render :index
    end
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def params_subject
    params.require(:subject).permit(:description)
  end
end
