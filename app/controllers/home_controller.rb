class HomeController < ApplicationController
    def index
        @requests = Request.where(requested_by_id: current_user.id).order(updated_at: :desc)
    end
end
