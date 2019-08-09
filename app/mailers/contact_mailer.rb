class ContactMailer < ApplicationMailer
  def build(contact)
    @contact = contact
    mail({
      from: @contact.email,
      to: 'admin@classpert.com',
      subject: @contact.subject || "New contact",
      reply_to: @contact.email
    })
  end
end