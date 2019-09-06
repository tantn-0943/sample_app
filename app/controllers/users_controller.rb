class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by params[:id]
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t(:translate,
        item: t("translates.Welcome_to_Sam_App"))
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
