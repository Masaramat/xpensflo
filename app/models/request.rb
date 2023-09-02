class Request < ApplicationRecord
  validates :narration, presence: true
  validates :account_id, presence: true
  validates :expense_type, presence: true
  validates :payment_type, presence: true
  validates :amount, presence: true, format: { with: /\A\d+\z/, message: "should only contain numbers" }
  enum status: [:pending, :vetted, :approved, :cleared, :paid, :finished, :rejected]
  enum payment_type: [:cash, :transfer]
  enum expense_type: [:operations, :admin]

  belongs_to :account
  belongs_to :requested_by, class_name: 'User', foreign_key: 'requested_by_id', optional: true
  belongs_to :vetted_by, class_name: 'User', foreign_key: 'vetted_by_id', optional: true
  belongs_to :approved_by, class_name: 'User', foreign_key: 'approved_by_id', optional: true
  belongs_to :cleared_by, class_name: 'User', foreign_key: 'cleared_by_id', optional: true
  belongs_to :paid_by, class_name: 'User', foreign_key: 'paid_by_id', optional: true
  has_many :notifications, dependent: :destroy
  has_many :rejections, dependent: :destroy
end
