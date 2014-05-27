#!/usr/bin/env perl
# Date Modified: May 26 , 2014
# Date Created : May 0, 2014
# Author Boris Sadkhin
# Summary: Use this tool to subtract items items from a todo list and see what is left on the todo list  
use strict;

my $to_process = $ARGV[0];
my $processed = $ARGV[1];
my $usage = "\n --usage compare_two_lists.pl <Set Of Files to Process> <A list of files that have been processed> --return A list of files that still need to be processed \n";

if(scalar @ARGV < 2){
        print "scalar @ARGV\n";
        die $usage;
}

open F, $to_process or die $! . $usage . "\n";
open G, $processed  or die $! . $usage . "\n";

my @to_process = <F>;
my @processed  = <G>;

my %to_process = map {($_, undef)} @to_process;

foreach my $completed_item(@processed){
        delete $to_process{$completed_item};
}

print sort keys %to_process;
