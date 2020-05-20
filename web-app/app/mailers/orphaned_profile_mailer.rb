class OrphanedProfileMailer < ApplicationMailer
  def build(orphaned_profile, to, locale)
    @orphaned_profile, @to, @locale = orphaned_profile, to, locale
    mail({
      from: 'Classpert <admin@classpert.com>',
      to: @to,
      subject: t('emails.orphaned_profile.build.subject'),
      reply_to: 'Classpert <admin@classpert.com>'
    })
  end
end

