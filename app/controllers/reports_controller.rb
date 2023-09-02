class ReportsController < ApplicationController
    before_action :set_form_values, only: [:index, :general_reports]
  
    def index
      @requests = initial_general_report
    end
  
    def daily_reports
      @requests = initial_daily_report
      render :index # Render the same view as index
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
  
