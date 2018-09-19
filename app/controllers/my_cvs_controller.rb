class MyCvsController < ApplicationController

  include CvHelper

  before_action :require_login, except: [:update_cv_email]
  skip_before_action :verify_authenticity_token, only: [:update_cv_email]

  layout "cv_catalogue_pages"


  def edit
    
  end

  def update_cv
    handle_cv_upload edit_my_cv_path
  end

  def update_cv_email
    ap mailgun_email_permitted_params
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