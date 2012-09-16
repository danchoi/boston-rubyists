## Description

This is a fork of [boston-rubyists](https://github.com/danchoi/boston-rubyists) for
[relevancers](http://relevancers.herokuapp.com/).
This fork does the following differently:

* Runs on heroku
* Twitter and github users can be configured in yaml
* Date fixes
* Styling improved by @michaelparenteau

I'll try to merge as much of this upstream when I get a chance.

# OLD README BELOW

# boston-rubyists

This project lets you easily set up a super-[planet][planet] that aggregates the GitHub feeds,
tweets, and blogs of your local hacker community.

It was created for [BostonRB][bostonrb] (Boston Ruby Group), but it's
configurable, so you can deploy a version for your own hacker community.

The tool is built with [Backbone.js][backbone], so that the landing page will
update itself with new information as it gets inserted into the database by
background tasks. The background tasks are also provided.

[planet]:http://en.wikipedia.org/wiki/Planet_%28software%29
[bostonrb]:http://bostonrb.org/
[backbone]:http://documentcloud.github.com/backbone/


Screenshot:

![img](https://github.com/danchoi/boston-rubyists/raw/master/screenshots/screen2.png)

The demo of this site can be seen [here][demo], unless it is down.

[demo]:http://poddb.com:9292

## Requires

* PostgreSQL
* Ruby 1.9
* tidy (HTML tidy) should be on your path

## Setup

Install dependences:

    bundle install

Configure the database connection and the data feeds in `config.yml`. You can
copy the pattern in `config.yml.example`:

    database: postgres:///bostonruby
    page_title: boston rubyists
    poll_interval: 8
    org:
      name: bostonrb.org
      href: http://bostonrb.org
    opml: http://www.blogbridge.com/rl/291/Boston+Ruby.opml
    twitters: https://github.com/bostonrb/bostonrb/wiki/All-Rubyists
    language: ruby
    locations:
    - cambridge+ma
    - boston
    - somerville+ma
    - salem+ma
    - providence+ri
    - salem+ma
    - portsmouth+nh
    - portland+me

* `opml` is an OPML file that contains a list of all the blogs you want to aggregate.
* `locations` is a list of GitHub search "location" filters.
* `language` is a programming language filter to use for the GitHub users search.
* `poll_interval` is the interval in seconds at which the Backbone.js client code should poll the Sinatra app for updates. Sorry, no websockets yet.
* `twitters` is a URL of a page that contains a list of Twitter user URLs

Set up the database you configured in config.yml like this, substituting the
right name for your database.

    createdb bostonruby
    psql bostonruby < schema.psql

## Running on Heroku

Running this app on Heroku requires a config var used by blogs.rb to reference a bundled tidy binary made necessary by feed_yamlizer. 

Using the [heroku toolbelt](https://toolbelt.heroku.com/) ...

    heroku config:set RUNNING_ON=heroku

## Populating the database

There are four rake tasks you should run to populate the data:

    rake hackers
    rake updates
    rake blogs
    rake tweets

Run `rake hackers` first to populate the hackers table in the database.

The other three tasks should be run periodically to keep the content up to date. Use cron or
some other tool.

## Running the webapp

    rackup


## Contribute

Please feel free to fork and enhance.

If you want to use this for another set of hackers and bloggers, please do and
please drop me a line to let me know you're using this tool!


## Authors

* Daniel Choi [github](https://github.com/danchoi) [twitter](http://twitter.com/danchoi)
