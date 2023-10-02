class DebitCredit < ApplicationRecord
    validates :amount, presence: true
    validates :amount_in_words, presence: true
    validates :dr_account, presence: true
    validates :cr_account, presence: true
    validates :dr_account_name, presence: true
    validates :cr_account_name, presence: true
    validates :cr_narration, presence: true
    validates :dr_narration, presence: true

    enum status: [:pending, :approved, :paid]
    enum trx_type: [:loan_disbursement, :transfer]

    belongs_to :initiated_by, class_name: 'User', foreign_key: 'initiated_by_id', optional: false
    belongs_to :approved_by, class_name: 'User', foreign_key: 'approved_by_id', optional: true
    belongs_to :paid_by, class_name: 'User', foreign_key: 'paid_by_id', optional: true
end
