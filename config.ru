# require "./app"

# run Sinatra::Application

# # log puts
# $stdout.sync = true

require File.join(File.dirname(__FILE__), "app")

run TvBot

# Heroku puts output to log
$stdout.sync = true