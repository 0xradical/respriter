module DeviseHelper
  include ErrorsHelper

  def devise_error_messages!
    error_messages!(resource)
  end
end
