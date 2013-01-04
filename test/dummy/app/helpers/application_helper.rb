module ApplicationHelper
  def current_user
    request.env["CURRENT_USER_ID"]
  end
end
