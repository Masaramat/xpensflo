json.extract! request, :id, :amount, :account_id, :comment, :narration, :requested_by_id, :vetted_by_id, :approved_by_id, :cleared_by_id, :paid_by_id, :created_at, :updated_at
json.url request_url(request, format: :json)
