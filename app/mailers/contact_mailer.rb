class ContactMailer < ApplicationMailer
  def build(contact)
    @contact = contact
    mail({
      from: from(@contact),
      to: "support@classpert.com",
      subject: subject(@contact),
      reply_to: "support@classpert.com"
    })
  end

  def from(contact)
    if contact.name.present?
      "#{contact.name} <#{contact.email}>"
    else
      contact.email
    end
  end

  def subject(contact)
    "#{tag(contact)} #{contact.subject}"
  end

  def tag(contact)
    case contact.reason
    when "customer_support", "manual_profile_claim"
      "[customer-support]"
    when "bug_report"
      "[customer-support][bug]"
    when "feature_suggestion"
      "[customer-support][feature]"
    when "commercial_and_partnerships"
      "[contact]"
    else
      "[contact]"
    end
  end
end