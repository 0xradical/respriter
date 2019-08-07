class ContactMailer < ApplicationMailer
  def build(contact)
    @contact = contact
    mail({
      subject: @contact.subject || "New contact",
      reply_to: @contact.email
    })
  end
end