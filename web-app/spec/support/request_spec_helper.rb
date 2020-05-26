module RequestSpecHelper

  def sign_in_as_admin
    admin = create(:admin_account)
    sign_in admin
    admin
  end

  def json_payload
    response.parsed_body
  end

end
