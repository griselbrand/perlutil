#!/usr/bin/env perl


use warnings;
use strict;
use 5.022;
use lib 'lib';

use Mydb 'db_handle';

my $dbh = db_handle('phs85');
my $sql_media_type = <<"SQL";
CREATE TABLE IF NOT EXISTS media_type (
	id			INTEGER		PRIMARY KEY,
	media_type	VARCHAR(10)	NOT NULL
	);
SQL

$dbh->do($sql_media_type);

my $sql_media = <<"SQL";
CREATE TABLE IF NOT EXISTS media (
	id			INTEGER			PRIMARY KEY,
	name		VARCHAR(255)	NOT NULL,
	location	VARCHAR(255)	NOT NULL,
	source		VARCHAR(511)	NOT NULL,
	attribution	VARCHAR(255)	NOT NULL,
	media_type_id	INTEGER		NOT NULL,
	license_id		INTEGER		NOT NULL
	);
SQL

$dbh->do($sql_media); 

