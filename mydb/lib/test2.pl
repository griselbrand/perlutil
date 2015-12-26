use strict;
use warnings;


my $word = "C0110";

my $real = "12.30";


print "\$word is word\n" if ($word =~ m/[[:alpha:]]/);

print "\$word is real number\n" if ($word =~ m/\d/);

print "\$real is word\n" if ($real =~ m/[[:alpha:]]/);

print "\$real is real number\n" if ($real =~ m/\d\.\d/);


print "it doesn't exist!\n" if (!$word);
