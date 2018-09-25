class MyCvsController < ApplicationController

  include CvHelper

  before_action :require_login, except: [:update_cv_email]
  skip_before_action :verify_authenticity_token, only: [:update_cv_email]

  layout "cv_catalogue_pages"


  def edit
    
  end

  def update_cv
    upload_cv_via_form edit_my_cv_path, current_user
  end

  def update_cv_email
    upload_cv_via_email mailgun_email_permitted_params
  end

  def resend_cv_email
    current_user.send_cv_submission_mail user_requested: true
    head :no_content
  end

  def mailgun_email_permitted_params
    params.permit(
      "Content-Type",
      "Date",
      "From",
      "In-Reply-To",
      "Message-Id",
      "Mime-Version",
      "Received",
      "References",
      "Sender",
      "Subject",
      "To",
      "User-Agent",
      "X-Mailgun-Variables",
      "attachment-count",
      "body-html",
      "body-plain",
      "content-id-map",
      "from",
      "message-headers",
      "recipient",
      "sender",
      "signature",
      "stripped-html",
      "stripped-signature",
      "stripped-text",
      "subject",
      "timestamp",
      "token",
      "attachment-1",
      "controller",
      "action"
    )
  end

end