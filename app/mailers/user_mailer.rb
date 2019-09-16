class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t(:translate,
      item: t("translates.Account activation"))
  end
end
