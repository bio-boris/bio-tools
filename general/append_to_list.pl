#!/usr/bin/env perl
# Date Modified: Nov , 2014
# Date Created : May 0, 2014
# Author Boris Sadkhin
# Summary: Use this tool to append a suffix to a list. Either choose STDIN or a file
use strict;
use Getopt::Long;

my $fh;
my $file   ;
my $append = $ARGV[0];
GetOptions (
                "f=s" => \$file,
                "a=s"   => \$append
           ) or die "Incorrect usage!\n";      # string



my $usage = "--usage append.pl -f<list|> -a<string to append>\n";

if(length $append == 0 && $#ARGV ==0){
        print $usage; exit;
}

if(length $file > 0 ){
        print "About to open $file\n";
        open F, $file or die $!, "Cannot find $file\n";
        while(<F>){
                chomp;
                print "$_$append\n";
        }
        close F;
}
else{
        while(<STDIN>){
                chomp;
                print "$_$append\n";
        }
}
