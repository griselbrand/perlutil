#!/usr/bin/env perl
# database handle for dbname 'phs85'

package Mydb;

use strict;
use warnings;
use 5.022;
use feature 'signatures';
no warnings "experimental::signatures";

use Exporter::NoWork;
use DBI;
use Carp 'croak';

sub db_handle($db) {

	print "id : ";
	my $id = <<>>;

	print "password : ";
	my $pass = <<>>;

	chomp($id, $pass);

	no warnings 'once';

	return DBI->connect(

		"dbi:Pg:dbname=$db;host=localhost;port=5432",$id, $pass,
		{ RaiseError => 1, PrintError => 0, AutoCommit => 1 },

	) || die $DBH::errstr;
}

1;
