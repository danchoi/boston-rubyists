# boston-rubyists

The demo of this site can be seen at http://poddb:9292, unless it is down.

## Requires

* PostgreSQL
* Ruby 1.9

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
    locations: 
    - cambridge+ma 
    - boston 
    - somerville+ma 
    - salem+ma 
    - providence+ri 
    - salem+ma 
    - portsmouth+nh 
    - portland+me

`opml` is an OPML file that contains a list of all the blogs you want to
aggregate. `locations` is a list of GitHub search "location" filters.

`poll_interval` is the interval in second you want the Backbone.js client code to
poll the Sinatra app for updates.  Sorry, no websockets yet.

Set up the database you configured in config.yml like this, substituting the 
right name for your database.

    createdb bostonruby
    psql bostonruby < schema.psql

## Populating the database

There are three rake tasks you should run to populate the data:

    rake hackers

    rake updates

    rake blogs

Run `rake hackers` first to populate the hackers table in the database.

The other two tasks should be run periodically to keep the content up to date. Use cron or 
some other tool.


