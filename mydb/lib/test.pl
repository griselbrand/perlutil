
use strict;

use warnings;

my @list;

foreach (0..10) {
foreach (0..99) {

push @{$list[$_]}, $_;

}
}

print @list;
print $#list;

foreach my $ref (@list) {

	print "@$ref\n";

}
