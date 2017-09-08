# tvbot

*tvbot* is a Slack bot that allows you to look up tv shows, (un)follow them and get notified when a new episode has aired.

It's written in Ruby/Sinatra, with a mongodb backend.

# Get it up and running

- create a [Slack App](https://api.slack.com/apps) (Slash Commands)
- get an [API key](https://www.themoviedb.org/account/signup) from [TMDb](https://www.themoviedb.org)
- deploy *tvbot* somewhere and make sure the Slack App's API token (_SLACK_TOKEN_), Slack App's OAuth token (_SLACK_OAUTH_TOKEN_) and TMDb's API token (_THEMOVIEDB_API_TOKEN_) are available in the environment (.env or something)

# How to

`/tv help`
Helps you along the way.

`/tv search tv show` 
Finds out things about *tv show*. In the results you can follow/unfollow tv shows.

`/tv list`
List the tv shows you follow.

Every 24 hours your list is checked against what's been on tv.
You will get a private message if something has aired.