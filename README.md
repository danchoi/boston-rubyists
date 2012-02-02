# boston-rubyists

The demo of this site can be seen at http://poddb:9292, unless it is down.

## Requires

* PostgreSQL
* Ruby 1.9

## Install

Install dependences

    bundle install

Set up the database

    createdb bostonruby
    psql bostonruby < schema.psql
    echo 'postgres:///bostonruby' > database.conf

Configure the data feeds in `config.yml`. You can copy the pattern in `config.yml.example`.

    page_title: boston rubyists
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

