# Start Postgres  

# use Docker CLI to login to the shell (this will provide root access)
In order to stat postgres. 

# start postgres
runuser -l postgres -c '/usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main -c config_file=/etc/postgresql/12/main/postgresql.conf'

# switch to postgres
su postgres

# create a test database
createdb -U postgres fleet

# log into the database
psql -U postgres fleet

# create a table (inside psql)
CREATE TABLE user2 (
	user_id serial PRIMARY KEY,
	username VARCHAR ( 50 ) UNIQUE NOT NULL,
	password VARCHAR ( 50 ) NOT NULL,
	email VARCHAR ( 255 ) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
        last_login TIMESTAMP 
);

# list the table definition (inside psql)
 \d user2

# Jovyan account
Your user name is jovyan
According to choldgraf, a distinguished contributor,
"Jovyan is often a special term used to describe members of the Jupyter community (https://jupyter.readthedocs.io/en/latest/community/content-community.html#what-is-a-jovyan 645).
tl;dr: it’s a play on “jovian” which means “a Jupiter-like planet” :slight_smile:"