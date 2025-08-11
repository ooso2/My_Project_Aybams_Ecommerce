class SessionsController < ApplicationController
  def destroy
    sign_out(current_user) if current_user
    redirect_to root_path, notice: 'Signed out successfully.'
  end
end