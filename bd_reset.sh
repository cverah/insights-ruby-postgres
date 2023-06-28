dropdb insights
createdb insights
psql -d insights < create.sql
ruby insert_data.rb insights data.csv
psql -d insights