How to create sqlite3 table :

$: gem install sqlite3
$: sqlite3 z_pause_prod ##z_pause_prod is the database name
> create table pauses(day datetime,  duration int);
> create table temp(start_time datetime);

How to use this script :
ruby pause.rb
It automaticaly detecte if its a start or stop
