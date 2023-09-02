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
                Request.arel_table[:status].eq('pending').and(
                  User.arel_table[:branch_id].eq(user.branch_id).and(
                    Request.arel_table[:expense_type].eq('operations')
                  )
                ).or(
                  Request.arel_table[:status].eq('cleared')  # Include cleared requests
                )
            )
    when 'head_admin'
      requests = Request.joins(:requested_by)  # Join requests with users table based on requested_by_id
                .where(
                  Request.arel_table[:status].eq('pending').or(
                    Request.arel_table[:status].eq('cleared')
                  ).and(
                    User.arel_table[:branch_id].eq(user.branch_id)  # Compare branch_id from users table with user's branch_id
                  ).and(
                    Request.arel_table[:expense_type].eq('admin')
                  )
                )
    when 'md'
      target_branch = Branch.find_by(name: 'Head office')
     
      if target_branch
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
      end
    when 'bm'
      requests = Request.joins(:requested_by)  # Join requests with users table based on requested_by_id
                .where(
                  Request.arel_table[:status].eq('vetted').and(
                    User.arel_table[:branch_id].eq(user.branch_id)  # Compare branch_id from users table with user's branch_id
                  ).and(
                    Request.arel_table[:amount].lt(50000)
                  )
                )
    when 'auditor'
      target_branch = Branch.find_by(name: 'Head office')
     
      requests = Request.joins(:requested_by)  # Join requests with users table based on requested_by_id
                .where(
                  Request.arel_table[:status].eq('approved').and(
                    User.arel_table[:branch_id].eq(user.branch_id).or(
                      User.arel_table[:branch_id].eq(target_branch.id)  # Compare branch_id from users table with user's branch_id
                    )  # Compare branch_id from users table with user's branch_id
                  )
                )
    when 'cashier', 'ft'    
      requests = Request.where(
                  Request.arel_table[:paid_by_id].eq(user.id).and(
                    Request.arel_table[:status].eq('paid')
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
