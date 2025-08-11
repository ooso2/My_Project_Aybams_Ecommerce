class Payment < ApplicationRecord
  belongs_to :order

  validates :payment_method, :payment_status, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  enum payment_status: {
    pending: 'pending',
    processing: 'processing',
    completed: 'completed',
    failed: 'failed',
    refunded: 'refunded'
  }

  scope :successful, -> { where(payment_status: 'completed') }

  def completed?
    payment_status == 'completed'
  end

  def successful?
    completed?
  end
end