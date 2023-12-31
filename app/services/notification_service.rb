# app/services/notification_service.rb

class NotificationService
    def self.create_notifications(request)
        notifications = []
        case request.status
        when "rejected"
          next_approver = request.requested_by
          notifications.push(Notification.create(
            user: request.requested_by,
            request: request,
            message: "Your request has been rejected" 
          ))
          
        when "paid"
          next_approver = request.paid_by
          notifications.push(Notification.create(
            user: request.requested_by,
            request: request,
            message: "Your request has been approved to be paid by #{request.paid_by.name}" 
          ))
          notifications.push(Notification.create(
            user: request.paid_by,
            request: request,
            message: "A new request by #{request.requested_by.name} has been approved for you to pay"
          ))
        when "pending"
          next_approvers = []

          if request.requested_by.role == 'marketer'
            next_approvers = User.where(role: 'supervisor')
          else
            if request.requested_by.branch.name.casecmp("Head office") == 0 || request.amount > 49999       
              next_approver = User.where(role: "md")
              next_approver.each do |approver|
                next_approvers << approver
              end
            else
              next_approver = User.where(role: 'operation', branch: request.requested_by.branch)
              next_approver.each do |approver|
                next_approvers << approver
              end
            end 
          end 
          next_approvers.each do |approver|
            notifications.push(Notification.create(
              user: approver,
              request: request,
              message: "A new request by #{request.requested_by.name} has been forwarded for your approval"
            ))     
          
          end
        when "vetted"
          if request.amount < 50000          
            next_approver = User.find_by(role: 'bm', branch: request.requested_by.branch)
          else
            next_approver = User.find_by(role: "md")
          end
          notifications.push(Notification.create(
            user: next_approver,
            request: request,
            message: "A new request by #{request.requested_by.name} has been forwarded for your approval"
          ))
        when "approved"           
          next_approvers = User.where(role: 'auditor')         
    
          next_approvers.each do |approver|
            notifications.push(Notification.create(
              user: approver,
              request: request,
              message: "A new request by #{request.requested_by.name} has been forwarded for your approval"
            ))
          end
        when "cleared"
          if request.expense_type == 'adashe'
            next_approver = User.find_by(role: 'ft', branch_id: request.requested_by.branch_id)
          else
            if request.requested_by.branch.name.casecmp("Head office") == 0 
              next_approver = User.find_by(role: 'operation', branch: Branch.find_by(name: "Head office branch"))
            else
              next_approver = User.find_by(role: 'operation', branch: request.requested_by.branch)
            end
           
          end
          notifications.push(Notification.create(
            user: next_approver,
            request: request,
            message: "A new request by #{request.requested_by.name} has been cleared for payment"
          ))

        when "waiting"
          if request.requested_by.branch.name.casecmp("Head office") == 0 
            next_approver = User.find_by(role: 'bm', branch: Branch.find_by(name: "Head office branch"))
          else
            next_approver = User.find_by(role: 'bm', branch: request.requested_by.branch)
          end
          notifications.push(Notification.create(
            user: next_approver,
            request: request,
            message: "A new request by #{request.requested_by.name} has been cleared for payment"
          ))
    
        else
    
        end
        notifications.each do |notification|
          user = notification.user
          NotificationChannel.broadcast_to(user, { notifications: user.notifications, count: user.notifications.count, notification: notification })
        end
      end 

      
  end
  