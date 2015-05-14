# See https://devcenter.heroku.com/articles/deploying-rails-applications-with-
# the-puma-web-server
unless Rails.env.test?
  # Rack::Timeout.timeout = 20 # seconds
  Rack::Timeout.timeout = 0 # seconds
end
