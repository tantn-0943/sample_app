class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user&.authenticate(session_params[:password])
      log_in user
      active_remember user
      redirect_back_or user
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

  def active_remember user
    @ifremember = session_params[:remember_me] == Settings.length.remember
    @ifremember ? remember(user) : forget(user)
  end
end
