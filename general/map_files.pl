#!/usr/bin/env perl
use strict;


my $map = 'a-z';
my $data = 'data';

open F, $map or die $!;

#Load a-z file into hash
my %hash;
while(my $line = <F>){
        chomp $line;
        $hash{$line} = undef;
}
close F;


#Populate hash with data from datafile

open F, $data or die $!;
while(my $line = <F>){
        chomp $line;
        my $delimiter ="\t";
        my ($key,$value) = split /$delimiter/, $line;
        $hash{$key} = $value;
}
close F;

foreach my $key(sort keys %hash){
        print "$key\t$hash{$key}\n";
}
