# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def account_activation
    user = User.find_by(email: "tran.ngoc.tan@sun-asterisk.com")
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  def password_reset
    UserMailer.password_reset
  end
end
