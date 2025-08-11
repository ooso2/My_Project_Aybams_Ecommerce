class OrderPolicy < ApplicationPolicy
  def show?
    user.present? && (record.user == user || user.admin?)
  end

  def index?
    user.present?
  end
end