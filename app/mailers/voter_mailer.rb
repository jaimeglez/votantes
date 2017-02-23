class VoterMailer < ApplicationMailer
  default from: 'votanteapp@gmail.com'

  def download_app_email(voter)
    @voter = voter
    mail(to: @voter.email, subject: 'Descarga Votantes app')
  end
end
