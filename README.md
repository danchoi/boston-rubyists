# boston-rubyists

This project lets you easily set up a super-[planet][planet] that aggregates the GitHub feeds, 
tweets, and blogs of your local hacker community. 

It was created for [BostonRB][bostonrb] (Boston Ruby Group), but it's
configurable, so you can deploy a version for your own hacker community.

[planet]:http://en.wikipedia.org/wiki/Planet_%28software%29
[bostonrb]:http://bostonrb.org/


Screenshot:

![img](https://github.com/danchoi/boston-rubyists/raw/master/screenshots/screen.png)

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
* `language` is a programming language filter to use for the GitHub userssearch.
* `poll_interval` is the interval in second you want the Backbone.js client code to poll the Sinatra app for updates. Sorry, no websockets yet.
* `twitters` is a URL of a page that contains a list of Twitter user URLs

Set up the database you configured in config.yml like this, substituting the 
right name for your database.

    createdb bostonruby
    psql bostonruby < schema.psql

## Populating the database

There are four rake tasks you should run to populate the data:

    rake hackers
    rake updates
    rake blogs
    rake twitters

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
