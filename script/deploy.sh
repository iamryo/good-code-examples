#!/bin/bash

set -e

APP_NAME=$1

# Heroku toolbelt autoupdates itself and will exit a command if currently
# updating, so manually trigger an update.
if [ -n $CI ]; then
  sudo apt-get -y install heroku-toolbelt
else
  heroku update
fi

# Install the Heroku Pipeline Plugin, not installed by default.
heroku plugins:install git://github.com/heroku/heroku-pipeline.git

if [ $APP_NAME == 'nightingale-integration' ]; then
  UPSTREAM_APP_NAME='nightingale-build-slug'
elif [ $APP_NAME == 'nightingale-staging' ]; then
  UPSTREAM_APP_NAME='nightingale-integration'
elif [ $APP_NAME == 'nightingale-production' ]; then
  UPSTREAM_APP_NAME='nightingale-staging'
else
  echo "Invalid app name."
  exit 1
fi

# Enable maintenance mode, promote the upstream pipeline app, run migrations
heroku maintenance:on nightingale-a $APP_NAME
heroku pipeline:promote $APP_NAME -a $UPSTREAM_APP_NAME

# Reset staging db to match production
if [ $APP_NAME == 'nightingale-staging' ]; then
  echo "Copying production database to staging..."
  heroku pgbackups:capture -a nightingale-production --expire
  heroku pg:reset -a $APP_NAME DATABASE_URL --confirm $APP_NAME
  PROD_DB_URL=`heroku pgbackups:url -a nightingale-production`
  heroku pgbackups:restore DATABASE_URL -a $APP_NAME --confirm $APP_NAME $PROD_DB_URL
fi

echo "Running migrations..."
heroku run rake db:migrate -a $APP_NAME
echo "Restarting the app..."
heroku restart -a $APP_NAME
echo "Disabling maintenance mode!"
heroku maintenance:off -a $APP_NAME

# Notify New Relic of a release to track before/after metrics
if [ $APP_NAME == 'nightingale-production' ]; then
  gem install newrelic_rpm
  newrelic deployments -a nightingale -r $REVISION -e production
fi
