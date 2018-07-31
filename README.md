# Hacquity

The Hacquity webapp was a hackathon project built as an experiment in addressing gender inequity in medicine and academia. It has two major modules, Second Shift and Mentor Match.

If you have hired help (like a nanny or a cleaner) but don't need them full time, or if you are looking for part time household help, Second Shift lets you connect with peers who can help.

Mentor Match helps you to discover other faculty who have interests like yours, and who are looking for mentor/mentee relationships.



## Development Setup

Hacquity is a Ruby on Rails app, the process getting set up for development with this project should be familiar to most rails developers. The app is built on Google Drive for CV file storage and search, which requires some credential setup.


### Prerequisites
- [RVM](https://rvm.io/)
- Postgres SQL (< 10.3)


### Steps

- Clone ths repository
- Change into the project directory, follow RVM's directions to install the needed Ruby version, and use `bundle install` to install prerequisite gems
- Visit the [Google developer's console](console.developers.google.com), and activate the Google Drive API for your google account.
- Visit the credentials section of the developer's console and create a set of service account keys for development, and store them in a file at the root of the project directory named `google-drive-keys.sh`. Note that this file is in `.gitignore`, don't check in these credentials. See `app/models/concerns/GoogleDrive.rb` for details on how these credentials are used. 
- `source google-drive-keys.sh && rails s`


## Deployment

- Repeat the steps given in setup for creating a Google service account, but this time give the account a name indicating that it will be used in production
- Create an app with Heroku, and add it as a git remote on your local repository
- In the Heroku dashboard, set the three service account related environment variables
- `git push heroku HEAD:master`




# Future Work

Note that this app was built in haste for a hackathon! There are numerous tasks to do to bring it up to production quality. In particular:

- There should be tests
- More authentication checks on most actions
- Much more careful handling of user files on Google Drive

