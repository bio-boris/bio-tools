#!/usr/bin/env perl
# Date Modified : May 27, 2014
# Date Created  : May 27, 2014
# Author        : Boris Sadkhin
# Summary       : Move a list of files to a directory

use strict;
my $usage = "--usage $0 <list_of_files> <destination>";

if(scalar @ARGV != 2){
        die $usage,"\n";
}
my $list_of_files = $ARGV[0];
my $destination = $ARGV[1];

open F, $list_of_files or die $!. " Cannot open files $list_of_files\n";
while(my $file = <F>){
        chomp $file;
        my $command = "mv $file $destination";
        print "$command\n";
        system($command);
}
close F;
