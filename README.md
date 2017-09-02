# tvbot

*tvbot* is a Slack bot that looks up your tv programs, and notifies you when a new episode has aired.
It's written in Ruby/Sinatra.

# Get it up and running

- create a [Slack App](https://api.slack.com/apps) (Slash Commands)
- get a [API key](https://www.themoviedb.org/account/signup) from [TMDb](https://www.themoviedb.org)
- deploy *tvbot* somewhere and make sure Slack App's API token (_SLACK_TOKEN_) and TMDb's API token (_THEMOVIEDB_API_TOKEN_) are available in the environment (.env or something)

# How to

`/tv help`
Helps you along the way.

`/tv search tv program` 
Finds out things about *tv program*.

`/tv follow tv program`
Starts following *tv program* and notifies you when a new episode has been aired.

`/tv unfollow tv program`
Unfolloes *tv program*.
