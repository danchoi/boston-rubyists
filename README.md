

    createdb bostonruby
    psql bostonruby < schema.psql
    echo 'postgres:///bostonruby' > database.conf
    
    # create list of programmers in programmers.txt by github username
    ruby search.rb boston ma > programmers.txt
    ruby search.rb cambridge ma >> programmers.txt

    # get all updates
    ruby parser.rb
