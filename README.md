# boston-rubyists

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

## Running the webapp

    rackup


## Contribute

Please feel free to fork and enhance.

If you want to use this for another set of hackers and bloggers, please do and
please drop me a line to let me know you're using this tool!


## Authors

* Daniel Choi [https://github.com/danchoi](github) [http://twitter.com/danchoi](twitter)
