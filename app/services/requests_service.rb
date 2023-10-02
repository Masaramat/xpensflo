class RequestsService
  attr_reader :request, :user

  def initialize(request, user)
    @request = request
    @user = user
  end

  def create_request
    @request.requested_by = @user
    @request.status = :pending
    if @request.save
      true
    else
      false
    end
  end

  def get_users(user)
    case user.role
    when 'operation'
      requests = Request.joins(:requested_by)
        .where(
          status: 'pending',
          users: { branch_id: user.branch_id },
          expense_type: 'operations'
        )
        .or(
          Request.joins(:requested_by)
            .where(
              status: 'cleared',
              users: { branch_id: user.branch_id }
            )
        )
    when 'head_admin'
       # Join requests with users table based on requested_by_ids
      requests = Request.joins(:requested_by) 
        .where(
          Request.arel_table[:status].eq('pending').and(
            # Compare branch_id from users table with user's branch_id
            User.arel_table[:branch_id].eq(user.branch_id)  
          ).and(
            Request.arel_table[:expense_type].eq('admin')
          )
        )
    when 'md'
      target_branch = Branch.find_by(name: 'Head office')   
      
      requests = Request.joins(:requested_by)  # Join requests with users table based on requested_by_id
        .where(
          Request.arel_table[:status].eq('vetted').and(
            Request.arel_table[:amount].gt(49900)
          ).or(
            User.arel_table[:branch_id].eq(target_branch.id)  # Compare branch_id from users table with user's branch_id
          ).and(
            Request.arel_table[:status].eq('pending')
          )
        )
      
    when 'bm'
      if user.branch.name.downcase == 'head office branch'
        target_branch = Branch.find_by("LOWER(name) = ?", 'head office')
        requests = Request.joins(:requested_by)
          .where(
            status: ['waiting', 'vetted'],
            users: { branch_id: [user.branch_id, target_branch.id] }
          ).or(
          Request.joins(:requested_by)
            .where(
              status: 'pending',
              users: { role: 'supervisor', branch_id: user.branch_id }
            )
        )
      else
        requests = Request.joins(:requested_by)
          .where(
            status: 'vetted',
            users: { branch_id: user.branch_id }
          ).or(
            Request.joins(:requested_by)
              .where(
                status: 'pending',
                users: { role: 'supervisor', branch_id: user.branch_id }
              )
          )          

      end
      
    when 'auditor'     
      requests = Request.where(status: "approved")
    when 'supervisor'     
      requests = Request.joins(:requested_by)
          .where(            
              status: 'pending',
              users: { role: 'marketer', branch_id: user.branch_id }
            )
        
    when 'cashier'    
      requests = Request.where(paid_by_id: user.id, status: 'paid')

    when 'ft'
      requests = Request.joins(:requested_by).where(
        status: 'cleared', 
        users: { branch_id: user.branch_id }
      )or(
        Request.where(
          paid_by_id: user.id, status: 'paid'
        )
      )

    when 'user', 'admin'
      requests = Request.where(
        Request.arel_table[:requested_by_id].eq(user.id)
      )

    end

    return requests

  end

  def get_daily_report(user)
    today = Date.today
    start_of_today = today.beginning_of_day
    end_of_today = today.end_of_day
  
    requests = Request.where(
      Request.arel_table[:status].eq('finished')
        .and(Request.arel_table[:paid_by_id].eq(user.id))
        .and(Request.arel_table[:paid_at].gteq(start_of_today))
        .and(Request.arel_table[:paid_at].lteq(end_of_today))
    )
    return requests
  end

  def get_general_report(start_date = nil, end_date = nil, status = "all")
    if start_date.nil? && end_date.nil?
      today = Date.today
      start_date = today.beginning_of_month
      end_date = today.end_of_month
    end
    if status == "all"
      requests = Request.all
    else
      requests = Request.where(
        Request.arel_table[:created_at].gteq(start_date)
          .and(Request.arel_table[:created_at].lteq(end_date))
          .and(Request.arel_table[:status].eq(status))
      )
    end
    
    
    return requests
  end

end
