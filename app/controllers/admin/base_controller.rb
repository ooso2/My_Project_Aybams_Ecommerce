class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  layout 'admin'

  private

  def ensure_admin
    unless current_user&.role == 'admin' || current_user&.role == 1
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end