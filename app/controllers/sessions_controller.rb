class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email:
      session_params[:email].downcase)
    if user&.authenticate(session_params[:password])
      log_in user
      session_params[:remember_me] == Settings.length.remember ? remember(user) : forget(user)
      redirect_to user
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

  def session_params
    params.require(:session).permit(:name, :email, :password,
      :password_confirmation)
  end
end
