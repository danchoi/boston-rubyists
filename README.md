

    createdb bostonruby
    psql bostonruby < schema.psql
    echo 'postgres:///bostonruby' > database.conf
    
    # create list of programmers in programmers.txt by github username
    ruby parser.rb
