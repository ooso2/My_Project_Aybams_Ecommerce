class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :nullify

  # Define user roles
  enum role: { customer: 0, admin: 1, super_admin: 2 }

  # Validations
  validates :email, uniqueness: true

  # Instance methods
  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def address_line_1
    address
  end

  def full_address
    [address, city, province, postal_code, country].compact_blank.join(', ')
  end

  def admin?
    role == 'admin' || role == 'super_admin'
  end
end
