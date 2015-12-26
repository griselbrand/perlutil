
# Header =>
# Long live Perl.

#!/usr/bin/env perl

use warnings;
use strict;
use 5.022;
use lib 'lib';
use Mydb 'db_handle';
use Parse::CSV;
use Smart::Comments;

my $dbh = db_handle('600G1');



# Input file name => read whole data from the file 

my @raw_data;

print "input a data file name(.csv) : ";

chomp(my $file_name = <>);

my $csv = Parse::CSV->new( file => $file_name ) or die $!; 

while ( my $row = $csv->fetch ) { ### Parsing[...          ] done

	push @raw_data, $row;

}


## Begin header works


# seperate header

my $header = shift @raw_data;
my $last_index = @{$header} - 1 ;

# header dash -> under bar**

foreach (0..$last_index) { ### converting dash(-) to under bar(_)[..........          ] done

	$header->[$_] =~ s/-/_/g;

}

# now, $header is an arrayref. now @raw_data is pure a data sheet.




# header type analysis

my %header_type;

foreach my $num(0..$last_index) { ### Variable typing[..........          ] done
	
	foreach (0..9) {
		
		my $element = $raw_data[$_]->[$num];
		
		if ($element =~ m/([a-zA-Z])+/) {
			
			$header_type{$header->[$num]} = "VARCHAR(255)";
						
			} elsif ($element =~ m/\d\.\d/) {
				
				$header_type{$header->[$num]} = "REAL";

				} elsif ($element =~ m/^\d+$/ && !$header_type{$header->[$num]}) {

					$header_type{$header->[$num]} = "INTEGER";
				
				}
		}
}

# making SQL query from the headers =>


# making table

print "\n\nPlease enter a table name to write : ";
my $table_name = <>;

print "\nPlease enter a variable name as a primary key(eg. $header->[0] or $header->[1]..) : ";
my $primary_key = <>;
chomp $primary_key;

die "no such variable!\n" unless (grep { $_ eq $primary_key } @{$header});

my $table_var; #Table attributes with format

foreach (0..$last_index) {

	unless ($header->[$_] eq $primary_key) {

		$table_var .= "$header->[$_]	$header_type{$header->[$_]}	NOT NULL";

	}

	if ($header->[$_] eq $primary_key) {

		$table_var .= "$header->[$_]	$header_type{$header->[$_]}	PRIMARY KEY";
	}
	
	$table_var .= ", " unless ($_ == $last_index);

}

my $sql_createtable = "CREATE TABLE IF NOT EXISTS $table_name ($table_var);";

# gotcha!

$dbh->do($sql_createtable) or die $!;

print "\ncreating a table is completed\n";

## End header works



## Begin Insertion ( will reimplement as transaction someday.. read PostgreSQL manual)

# make SQL query

my $col_name;

foreach (0..$last_index) {

	$col_name .= "$header->[$_]";

	$col_name .= "," unless ($_ == $last_index);

}

my $bind = '?, ' x ($last_index + 1);
chop $bind;
chop $bind; #remove last ', '

my $sql_insertion = "INSERT INTO $table_name ($col_name) VALUES ($bind)";
my $sth = $dbh->prepare($sql_insertion);

# insert!

foreach my $row(@raw_data) { ### Inserting data into the table[..........          ] done

	$sth->execute(@$row) || die $!;

}

print "\ncomplete!\n";
