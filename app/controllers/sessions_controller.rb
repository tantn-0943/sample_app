class SessionsController < ApplicationController
  before_action :find_email, only: :create
  def new; end

  def create
    if @user&.authenticate(sess_params[:password])
      if @user.activated?
        log_in @user
        active_remember @user
        redirect_back_or @user
      else
        redirect_to root_url
      end
    else
      flash.now[:danger] = t(:translate,
        item: t("translates.login_error"))
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def sess_params
    params.require(:session).permit(:name, :email, :password,
      :password_confirmation)
  end

  def active_remember user
    @ifremember = sess_params[:remember_me] == Settings.length.remember
    @ifremember ? remember(user) : forget(user)
  end

  def find_email
    @user = User.find_by(email: sess_params[:email].downcase)
  end
end
