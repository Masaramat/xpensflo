class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :authorize_auditor!, only: [:clear_request]
  before_action :authorize_operations!, only: [:vet_request, :pay_request]
  before_action :authorize_cashier_ft!, only: [:finish_request]
  before_action :authorize_user!, only: [:edit, :destroy]
  before_action :authorize_md_bm!, only: [:approve_request]
 

  def index
    @request = Request.new
    service = RequestsService.new(@request, current_user)
    @requests =service.get_users(current_user)
  end

  def daily_report
    @request = Request.new
    service = RequestsService.new(@request, current_user)
    @requests =service.get_daily_report(current_user)
    respond_to do |format|  
      format.html { render :daily_report }
    end
  end

  def general_reports
    @request = Request.new
    service = RequestsService.new(@request, current_user)
    @requests = service.get_general_report(params[:start_date], params[:end_date])
    puts "@requests: #{@requests.inspect}"
    
    respond_to do |format|  
      format.html { render :general_reports }
    end
  end
  

  def show
  end

  def new
    @request = Request.new
    @accounts = Account.all
  end

  def edit
    @accounts = Account.all
  end

  def create
    @request = Request.new(request_params)
    service = RequestsService.new(@request, current_user)

    if service.create_request
      NotificationService.create_notifications(@request)
      redirect_to request_url(service.request), notice: "Request was successfully created."
    else
      @accounts = Account.all
      respond_to do |format|  
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    service = RequestsService.new(@request, current_user)
    if service.update_request(request_params, current_user, params)
      redirect_to request_url(service.request), notice: "Request was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end



  def destroy
    @request.destroy
    redirect_to requests_url, notice: "Request was successfully destroyed."
  end

  def vet_request
    perform_request_action('vetted', current_user, nil)
  end

  def approve_request
    perform_request_action('approved', current_user, nil)
  end

  def clear_request
    perform_request_action('cleared', current_user, nil)
  end

  def pay_request
    paid_by_id = params[:request][:paid_by_id]
    perform_request_action('paid', current_user, paid_by_id)
  end

  def finish_request
    trx_code = params[:request][:trx_code]
    perform_request_action('finished', current_user, trx_code)
  end

 

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:amount, :account_id, :comment, :narration, :payment_type, :expense_type)
  end

  def perform_request_action(status, user, additional_param)
    @request = Request.find(params[:id])

    case status
    when 'vetted'
      update_request_status_for_operations(user)
      @request.vetted_at = Time.now()
    when 'approved'
      update_request_status_for_bm_md(user)
      @request.approved_at = Time.now()
    when 'cleared'
      update_request_status_for_auditor(user)
      @request.cleared_at = Time.now()
    when 'paid'
      update_request_status_for_operations(user)
      @request.paid_by_id = additional_param
    when 'finished'
      update_request_status_for_cashier(user)
      @request.paid_at = Time.now()
      @request.trx_code = additional_param
    end

    if @request.save
      redirect_to requests_url, notice: "Request was successfully updated."
      NotificationService.create_notifications(@request)      
      
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private 

    

  def update_request_status_for_operations(user)
    
    if @request.status == 'pending'
      @request.status = 'vetted'
      @request.vetted_by = user
    elsif @request.status == 'cleared'
      @request.status = 'paid'
    end
  end

  def update_request_status_for_bm_md(user)
    @request.status = 'approved'
    @request.approved_by = user
  end

  def update_request_status_for_auditor(user)
    @request.status = 'cleared'
    @request.cleared_by = user
  end

  def update_request_status_for_cashier(user)
    @request.status = 'finished'
  end

  def authorize_operations!
    redirect_to root_path, notice: 'Only operations can perform this task.' unless current_user.operation?
  end
  def authorize_md_bm!
    redirect_to root_path, notice: 'Only MD or BM can perform this task.' unless current_user.md? or current_user.bm?
  end
  def authorize_auditor!
    redirect_to root_path, notice: 'Only operations can perform this task.' unless current_user.auditor?
  end
  def authorize_cashier_ft!
    redirect_to root_path, notice: 'Only Cashier of FT can perform this task.' unless current_user.ft? or current_user.cashier?
  end

  def authorize_user!
    @request = Request.find(params[:id])
    redirect_to request_path(@request), notice: 'You cannot edit the request at this stage.' unless current_user == @request.requested_by and @request.status == "pending"
  end
  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
