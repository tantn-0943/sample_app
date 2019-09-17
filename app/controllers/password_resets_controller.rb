class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user,
    :check_expiration, only: [:edit, :update]
  def new; end

  def create
    @user = User.find_by(email:
      params[:password_reset_var][:email_form].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t(:translate,
        item: t("translates.sentpass"))
      redirect_to root_url
    else
      flash.now[:danger] = t(:translate,
        item: t("translates.notfound"))
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t(:translate,
        item: t("translates.hasbeenreset"))
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t(:translate,
        item: t("translates.exprice"))
    redirect_to new_password_reset_url
  end
end
