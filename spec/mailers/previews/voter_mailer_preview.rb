# Preview all emails at http://localhost:3000/rails/mailers/voter_mailer
class VoterMailerPreview < ActionMailer::Preview
  def voter_mail_preview
    VoterMailer.download_app_email(Voter.first)
  end
end
