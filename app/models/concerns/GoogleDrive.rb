require 'google/apis/drive_v3'
require 'googleauth'

module GoogleDrive

  # NB: This relies on a somewhat poorly documented feature of the Ruby client
  # for Google APIs: if three particular environment variables are defined, then
  # instead of using ADC (Application Default Credentials) 
  # to locate a json configuration file, it will pull from those env variables 
  # instead. This lets us play nice with Heroku in production.

  # See: https://stackoverflow.com/questions/34360932/google-api-oauth-2-0-how-to-store-application-default-credentials

  # In development, obtain a service account, create a google-drive-keys.sh like
  # export GOOGLE_PRIVATE_KEY=" ... "
  # export GOOGLE_CLIENT_EMAIL=" ... "
  # export GOOGLE_ACCOUNT_TYPE=" ... "

  # Be sure to strip the "/n"s out of the JSON, replace them with real newlines
  # in the private key.

  # Don't check this file in. Then in whatever shells need to run a Rails
  # process:
  # $ source google-drive-keys.sh
  # $ rails s

  # In production, set these environment variables through the Heroku panel.

  def self.get_drive_service
    drive = Google::Apis::DriveV3::DriveService.new

    # TODO: restrict this more?

    scope = [
      'https://www.googleapis.com/auth/drive'
    ]

    drive.authorization = Google::Auth.get_application_default(scope)

    drive
  end

end
