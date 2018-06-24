* Dependencies:
Ruby version: 2.5.1
PostgreSQL version: 9.5.13

* DB setup
Create user and database - run in psql console:
CREATE ROLE foodierecipe WITH createdb login password 'password';
CREATE DATABASE foodieRecipes_dev WITH owner=foodierecipe;

* Run migrations and seeds
rake db:migrate
rake db:seed

* Start server
rails s
