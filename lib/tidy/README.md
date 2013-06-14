Tidy on Heroku
===============

feed_yamlizer calls out to an external tidy binary; for heroku, this means we have to use a buildpack to provide it.

See the top-level README for the config var Heroku needs set.

If the Tidy binary needs to be re-compiled for any reason, the following steps explain the process.

This article was helpful: http://www.intridea.com/blog/2012/5/2/lessons-learned-compiling-tidy-html-natively-for-heroku

Get the tidy source at http://tidy.cvs.sourceforge.net/viewvc/tidy/tidy/ and unpack it into ./tidy/.

    $ gem install vulcan

    $ vulcan create tmp-app

    $ vulcan build -v -s tidy/ -p /tmp/tidy -c "sh build/gnuauto/setup.sh && ./configure --prefix=/tmp/tidy --with-shared && make && make install"

This will provide a URL with a downloadable tarball containing the necessary files.