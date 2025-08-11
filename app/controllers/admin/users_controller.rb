class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @user.id == current_user.id
      redirect_to admin_users_path, alert: 'You cannot delete your own account.'
    else
      @user.destroy
      redirect_to admin_users_path, notice: 'User was successfully deleted.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :phone, :address, :city, :province, :postal_code, :country)
  end
end
