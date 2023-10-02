class DebitCreditsController < ApplicationController
  before_action :set_debit_credit, only: [:show, :edit, :update, :destroy, :approve, :pay_debit_credit]
  before_action :authorize_approval!, only: [:approve]
  before_action :authorize_payment!, only: [:pay_debit_credit]
  before_action :authorize_creation!, only: [:new, :create, :edit, :update]

  # GET /debit_credits or /debit_credits.json
  def index
    @debit_credits = DebitCredit.where(initiated_by: current_user.id)
  end

  def pending_requests
    # Assuming you have a 'request' object available, replace it with the actual request you want to use.
    @debit_credits = DebitCreditService.pending_requests(current_user)
  end

  # GET /debit_credits/1 or /debit_credits/1.json
  def show
  end

  # GET /debit_credits/new
  def new
    @debit_credit = DebitCredit.new
  end

  # GET /debit_credits/1/edit
  def edit
  end

  def approve
    @debit_credit.status = "approved"
    @debit_credit.approved_by = current_user
    @debit_credit.approved_at = Time.now

    respond_to do |format|
      if @debit_credit.save
        format.html { redirect_to debit_credit_url(@debit_credit), notice: "Loan disbursement approved successfully created." }
        format.json { render :show, status: :created, location: @debit_credit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @debit_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  def pay_debit_credit
    @debit_credit = DebitCredit.find(params[:id])
    @debit_credit.status = "paid"
    @debit_credit.paid_by = current_user
    @debit_credit.paid_at = Time.now
    @debit_credit.cr_trx_code = params[:cr_trx_code]
    @debit_credit.dr_trx_code = params[:dr_trx_code]

    respond_to do |format|
      if @debit_credit.save
        format.html { redirect_to debit_credit_url(@debit_credit), notice: "Debit credit paid successfully created." }
        format.json { render :show, status: :created, location: @debit_credit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @debit_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /debit_credits or /debit_credits.json
  def create
    @debit_credit = DebitCredit.new(debit_credit_params)
    @debit_credit.initiated_by = current_user

    respond_to do |format|
      if @debit_credit.save
        format.html { redirect_to debit_credit_url(@debit_credit), notice: "Debit credit was successfully created." }
        format.json { render :show, status: :created, location: @debit_credit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @debit_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debit_credits/1 or /debit_credits/1.json
  def update
    respond_to do |format|
      if @debit_credit.update(debit_credit_params)
        format.html { redirect_to debit_credit_url(@debit_credit), notice: "Debit credit was successfully updated." }
        format.json { render :show, status: :ok, location: @debit_credit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @debit_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debit_credits/1 or /debit_credits/1.json
  def destroy
    @debit_credit.destroy

    respond_to do |format|
      format.html { redirect_to debit_credits_url, notice: "Debit credit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_debit_credit      
    @debit_credit = DebitCredit.find(params[:id])
  end
  
  def debit_credit_params
    params.require(:debit_credit).permit(
      :amount,
      :amount_in_words,
      :dr_account,
      :cr_account,
      :dr_account_name,
      :cr_account_name,
      :trx_type,
      :dr_narration,
      :cr_narration,
      :cr_trx_code,  
      :dr_trx_code 
    )
  end

  def authorize_approval!
    redirect_to debit_credits_path(@debit_credit), notice: "You don't have the authorization to perform this action." unless current_user.role == "operation" || current_user.role == "supervisor"
  end

  def authorize_creation!
    redirect_to debit_credits_path(@debit_credit), notice: "You don't have the authorization to perform this action."  unless current_user.role == "credit" || current_user.role == "marketer"
  
  end

  def authorize_payment!
    redirect_to debit_credits_path(@debit_credit), notice: "You don't have the authorization to perform this action." unless current_user.role == "ft"
  
  end 
end
