class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate page: params[:page], per_page: Settings.length.page
  end

  def new
    @user = User.new
  end

  def show
    flash[:success] = "#{params}, #{User.find_by(id: params[:id]).id}"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = t(:translate,
        item: t("translates.Welcome_to_Sam_App"))
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = "notfound"
    redirect_to root_path
  end
end
