#!/usr/bin/env perl
# Date Modified: Jun 20, 2014
# Date Created : Jun 20, 2014
# Author Boris Sadkhin
# Summary: Use this tool to prepend a prefix to a list. Either choose STDIN or a file
use strict;
use Getopt::Long;

my $fh;
my $file   ;
my $append = $ARGV[0];
GetOptions (
                "f=s" => \$file,
                "a=s"   => \$prepend
           ) or die "Incorrect usage!\n";      # string



my $usage = "--usage prepend_to_list.pl -f<list|> -a<string to prepend>\n";

if(length $append == 0 && $#ARGV ==0){
        print $usage; exit;
}

if(length $file > 0 ){
        print "About to open $file\n";
        open F, $file or die $!, "Cannot find $file\n";
        while(<F>){
                chomp;
                print "$prepend$_\n";
        }
        close F;
}
else{
        while(<STDIN>){
                chomp;
                print "$prepend$_\n";
        }
}
