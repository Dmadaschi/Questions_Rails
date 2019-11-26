# frozen_string_literal: true

class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :verify_password, only: [:update]
  before_action :set_admin, only: %i[update edit destroy]

  def index
    @admins = Admin.all.page(params[:page])
  end

  def edit; end

  def update
    # update total
    if @admin.update(params_admin)
      redirect_to admins_backoffice_admins_path, notice: 'successful update'
    else
      render :edit
    end
  end

  def new
    @admin = Admin.new
  end

  def create
    # create
    @admin = Admin.new(params_admin)

    if @admin.save
      redirect_to admins_backoffice_admins_path, notice: 'successful create'
    else
      render :new
    end
  end

  def destroy
    # delete
    if @admin.destroy
      redirect_to admins_backoffice_admins_path, notice: 'successful delete'
    else
      render :index
    end
  end

  private

  def verify_password
    # update apenas email
    if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
      params[:admin].extract!(:password, :password_confirmation)
    end
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def params_admin
    params.require(:admin).permit(
      :email, :password, :password_confirmation
    )
  end
end
