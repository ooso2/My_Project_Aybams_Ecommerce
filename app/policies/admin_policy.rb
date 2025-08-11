class AdminPolicy < ApplicationPolicy
  def dashboard?
    user&.admin?
  end

  def manage?
    user&.admin?
  end
end
