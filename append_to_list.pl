#!/usr/bin/env perl
# Date Modified: May 26 , 2014
# Date Created : May 0, 2014
# Author Boris Sadkhin
# Summary: Use this tool to append a suffix to a list 

my $usage = "--usage append_to_list.pl <list> <APPEND>";

if (scalar @ARGV !=2){
        die "$usage\n";
}
my $list   = $ARGV[0];
my $append = $ARGV[1];


open F , $list or die $!;

while(<F>){
        chomp;
        print "$_$append\n";

}
