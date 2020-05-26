class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    DeviseMailer.confirmation_instructions(UserAccount.find(351), "faketoken", {})
  end

  def reset_password_instructions
    DeviseMailer.reset_password_instructions(UserAccount.find(351), "faketoken", {})
  end

  def unlock_instructions
    DeviseMailer.unlock_instructions(UserAccount.find(351), "faketoken", {})
  end

  def email_changed
    DeviseMailer.email_changed(UserAccount.find(351), {})
  end

  def password_change
    DeviseMailer.password_change(UserAccount.find(351), {})
  end
end