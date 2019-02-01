# DoM Citizen

The DoM Citizen webapp was a hackathon project built as an experiment in addressing gender inequity in medicine and academia. It has several major modules, including: 

- Second Shift

    If you have hired help (like a nanny or a cleaner) but don't need them full time, or if you are looking for part time household help, Second Shift lets you connect with peers who can help.
- Mentor Match

    Mentor Match helps you to discover other faculty who have interests like yours, and who are looking for mentor/mentee relationships.
- Trusted Vendors

    Trusted Vendors is a place for reviews of people and companies who are trusted by members of the community. You can browse, search, post, and rate vendor reviews.
- CV Catalogue

    Search a database of CVs for members of the Department of Medicine.
- Administration

    Admins can invite users, approve or reject users who request to join the site, disable user accounts, and also perform bulk update operations on CVs available in the CV Catalogue and Mentor Match.





## Development Setup

DoM Citizen is a Ruby on Rails app, the process getting set up for development with this project should be familiar to most rails developers. The app ties into several external services for its features, which requires some credential setup, see the Variables section below.


### Prerequisites
- [RVM](https://rvm.io/)
- Postgres SQL (> 10.3)


### Steps

- Clone the repository
- Change into the project directory, follow RVM's directions to install the needed Ruby version, and use `bundle install` to install prerequisite gems
- Visit the [Google developer's console](console.developers.google.com), and activate the Google Drive API for your google account.
- Visit the credentials section of the developer's console and create a set of service account keys for development, and store them in a file at the root of the project directory named `google-drive-keys.sh`. Note that this file is in `.gitignore`, don't check in these credentials. See `app/models/concerns/GoogleDrive.rb` for details on how these credentials are used. 
- `source google-drive-keys.sh && rails s`

### Processes to run in development.
- `projects/mail/mailcatcher`. Development mode is set up to send email to a local Mailcatcher server. Install mailcatcher in a separate gemset, and visit `http://localhost:1080`
- `rails jobs:work` . Mail is also configured to be sent with DelayedJob. Use this to start the queue.


## Deployment

- Repeat the steps given in setup for creating a Google service account, but this time give the account a name indicating that it will be used in production
- Create an app with Heroku, and add it as a git remote on your local repository
- In the Heroku dashboard:
    - Set the three service account related environment variables
    - Set the `MAIL_HOST` environment variable
- `git push heroku HEAD:master`

## Variables

Since the app ties together quite a few services at this point (Sengrid, Mailgun, Google Drive, and Amazon S3) I'm including this authoritative list of all the environment variables that change around from environment to environment. They can all be recorded in `google-drive-keys.sh` in development, and sourced as the instructions above indicate.

- `GOOGLE_PRIVATE_KEY` 
- `GOOGLE_CLIENT_EMAIL` 
- `GOOGLE_ACCOUNT_TYPE` 
- `CV_SUBMISSION_EMAIL` the mailgun email to which messages containing attachments should be sent. 
- `MAILER_REPLY_TO_ADDRESS`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `S3_BUCKET_NAME` S3 is only needed for the multiple CV file upload feature, accessible from the admin panel.


# Future Work

Note that this app was built in haste for a hackathon! There are numerous tasks to do to bring it up to production quality. In particular:

- There should be tests
- More authentication checks on most actions (this is partially addressed)
- Much more careful handling of user files on Google Drive (this is largely addressed)

