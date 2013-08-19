# SCRC

This is a prototype for Econometrica. 

## Requirements & Installation

Node.js
Redis for session store
Postgresql

## Database Operations
# Dump local database
> pg_dump -Fc --no-acl --no-owner -h localhost -U postgres scrc > db.dump

# upload to https://console.aws.amazon.com/s3/home?region=us-west-2
# make it public
# get public url

# restore heroku database
> heroku pgbackups:restore DATABASE 'https://s3.amazonaws.com/econometrica/scrc/db.dump'
> git push heroku master

Pat Cappelaere	Vightel		pat@cappelaere.com