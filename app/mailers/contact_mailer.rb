class ContactMailer < ApplicationMailer
  def build(contact)
    @contact = contact
    mail({
      from: (@contact.name.present? ? "#{@contact.name} <#{@contact.email}>" : @contact.email),
      to: 'admin@classpert.com',
      subject: "New contact" + (@contact.subject.present? ? ": #{@contact.subject}" : ""),
      reply_to: @contact.email
    })
  end
end