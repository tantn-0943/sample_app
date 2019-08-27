class StaticPagesController < ApplicationController
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def home; end

  def help; end

  def about; end

  def contact; end
end
