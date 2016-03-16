class AdminsController < AuthenticatedController
  before_action :require_admin
  
  def require_admin
    redirect_to(home_path) unless current_user.admin?
  end
end