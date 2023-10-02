# app/services/debit_credit_service.rb

class DebitCreditService
  def self.pending_requests(user)
    if user.role == "supervisor"
      DebitCredit.joins(:initiated_by).where(
        status: "pending",
        users: { branch_id: user.branch_id },
        trx_type: "transfer"
      )
    elsif user.role == "operation"
      DebitCredit.joins(:initiated_by).where(
        status: "pending",
        users: { branch_id: user.branch_id },
        trx_type: "loan_disbursement"
      )
    elsif user.role == "ft"
      DebitCredit.joins(:initiated_by).where(
        status: "approved",
        users: { branch_id: user.branch_id },
        trx_type: "transfer"
      )
    else
      []
    end
  end
end
