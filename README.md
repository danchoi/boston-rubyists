

    createdb bostonruby
    psql bostonruby < schema.psql
    echo 'postgres:///bostonruby' > database.conf
