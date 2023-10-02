class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, presence: { message: "Name can't be blank" }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [
    :user, 
    :operation, 
    :head_admin, 
    :bm, 
    :md, 
    :cashier, 
    :ft, 
    :admin, 
    :auditor, 
    :credit, 
    :marketer,
    :supervisor
  ]
  belongs_to :branch
  belongs_to :department
  has_many :requested_requests, class_name: 'Request', foreign_key: 'requested_by_id', dependent: :destroy
  has_many :vetted_requests, class_name: 'Request', foreign_key: 'vetted_by_id', dependent: :destroy
  has_many :approved_requests, class_name: 'Request', foreign_key: 'approved_by_id', dependent: :destroy
  has_many :cleared_requests, class_name: 'Request', foreign_key: 'cleared_by_id', dependent: :destroy
  has_many :paid_requests, class_name: 'Request', foreign_key: 'paid_by_id', dependent: :destroy
  has_many :paid_debit_credits, class_name: 'DebitCredit', foreign_key: 'paid_by_id', dependent: :destroy
  has_many :initiated_debit_credits, class_name: 'DebitCredit', foreign_key: 'initiated_by_id', dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :rejections, dependent: :destroy

  def self.find_by_authentication_token(token)
    find_by(authentication_token: token)
  end
end
