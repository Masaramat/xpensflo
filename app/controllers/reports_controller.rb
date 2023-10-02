class ReportsController < ApplicationController
    before_action :set_form_values, only: [:index, :general_reports]
  
    def index
      @requests = initial_general_report
    end
  
    def daily_reports
      @requests = initial_daily_report
      render :daily_report # Render the same view as index
    end

    def daily_disbusements_report
      today = Date.today
      start_of_today = today.beginning_of_day
      end_of_today = today.end_of_day
    
      @debit_credits = DebitCredit.where(
        DebitCredit.arel_table[:created_at].gteq(start_of_today)
          .and(DebitCredit.arel_table[:trx_type].eq("loan_disbursement"))
          .and(DebitCredit.arel_table[:created_at].lteq(end_of_today))
      )     

    end

    def daily_transfers_report
      today = Date.today
      start_of_today = today.beginning_of_day
      end_of_today = today.end_of_day
    
      @debit_credits = DebitCredit.where(
        DebitCredit.arel_table[:created_at].gteq(start_of_today)
          .and(DebitCredit.arel_table[:trx_type].eq("transfer"))
          .and(DebitCredit.arel_table[:created_at].lteq(end_of_today))
      )

      @requests = Request.where(
        Request.arel_table[:paid_at].gteq(start_of_today)
          .and(Request.arel_table[:paid_by_id].eq(current_user.id))
          .and(Request.arel_table[:paid_at].lteq(end_of_today))
      )
    end

    def ft_daily_transfers_report
      today = Date.today
      start_of_today = today.beginning_of_day
      end_of_today = today.end_of_day
    
      @debit_credits = DebitCredit.where(
        DebitCredit.arel_table[:created_at].gteq(start_of_today)
          .and(DebitCredit.arel_table[:paid_by_id].eq(current_user.id))
          .and(DebitCredit.arel_table[:trx_type].eq("transfer"))
          .and(DebitCredit.arel_table[:created_at].lteq(end_of_today))
      )
    end

    def all_disbursements_report 
      @debit_credits = DebitCredit.where(trx_type: "loan_disbursement")

    end

    def all_transfers_report 
      @debit_credits = DebitCredit.where(trx_type: "transfer")

    end
  
    def general_reports
      @requests = service.get_general_report(params[:start_date], params[:end_date], params[:status])
      render :general_reports # Render the same view as index
    end
  
    private
  
    def set_form_values
      @request = Request.new
      @default_start_date = Date.today.beginning_of_month
      @default_end_date = Date.today.end_of_month
      @default_status = 'all'
    end
  
    def initial_general_report
      service.get_general_report(nil, nil, 'all')
    end
  
    def initial_daily_report
      service.get_daily_report(current_user)
    end
  
    def service
      @service ||= RequestsService.new(@request, current_user)
    end
  end
  
