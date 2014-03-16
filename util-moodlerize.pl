#!/usr/bin/perl

use strict;
use warnings;

open(CLASSLIST, 'list.csv');

my @linetokens;
my %emails;

while(<CLASSLIST>){
	chomp;
	@linetokens = split(/,/);
	$emails{"$linetokens[0] $linetokens[1]"} = $linetokens[5];
}

my $headerline = <>;
@linetokens = split(/,/, $headerline);
splice(@linetokens, 1, 0, "\"Email address\"");
print(join(',', @linetokens));

while(<>) {
	@linetokens = split(/,/);
	$linetokens[0] =~ tr/"//d;
	if (exists $emails{$linetokens[0]}) {
		splice(@linetokens, 1, 0, $emails{$linetokens[0]});
		print(join(',', @linetokens));
	} else {
		die "No student name: $linetokens[0]\n";
	}
}
