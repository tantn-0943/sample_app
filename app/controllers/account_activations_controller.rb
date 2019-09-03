class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit
  def edit
    if check_authenticate @user
      @user.update_attribute(:activated, true)
      @user.update_attribute(:activated_at, Time.zone.now)
      log_in @user
      flash[:success] = t(:translate,
        item: t("translates.accountss"))
      redirect_to @user
    else
      flash[:danger] = t(:translate,
        item: t("translates.accountunss"))
      redirect_to root_url
    end
  end

  def check_authenticate user
    user && !user.activated? && user.authenticated?(:activation, params[:id])
  end

  def load_user
    @user = User.find_by(email: params[:email])
  end
end
