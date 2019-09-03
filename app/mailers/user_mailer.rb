class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t(:translate,
      item: t("translates.account activation"))
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(:translate,
      item: t("translates.resetPassword"))
  end
end
