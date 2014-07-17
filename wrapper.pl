#!/usr/bin/env perl
# Description : A tool to split jobs for qsub
# Author: bio-boris

use strict;
use File::Basename;
use POSIX ();
my $usage = "\t\t--usage= $0 <PBS_ARRAYID> <MAX_JOBS> <SCRIPT_TO_CALL> <LIST_OF_SCRIPT_INPUTS_SMALLEST_TO_LARGEST>";

my ($PBS_ARRAYID,$MAX_JOBS,$SCRIPT,$INPUT_FILE) =  @ARGV;
if($PBS_ARRAYID < 0 || $MAX_JOBS <0){
    die "Incorrect PBSID or # of JOBS\n";
}
if(!$SCRIPT || not -s $SCRIPT){
    die "Script given does not exist\n";
}
if(!$INPUT_FILE || not -s $INPUT_FILE){
    die "Empty input file\n";
}
chomp(my $number_of_inputs = `wc -l $INPUT_FILE`);


#Logic for # of items to process
my $jobs = floor($number_of_inputs/$MAX_JOBS);
my $offset = $PBS_ARRAYID;
my $start = (($jobs * $offset) - $jobs) + 1 ;
my $finish = $start + $jobs;


for(my $i = $start ; $i <= $finish; $i++){

    my $command = "sed -n " . $i . "p $INPUT_FILE";
    my $input_line = `$command`;
    chomp $input_line;

    print "******\n\n";
    print "About to send input_line($i):$input_line to $SCRIPT  OFFSET/PBSARRAY_ID=$offset START:$start-FINISH:$finish \n";
    print "*******\n\n";
    
   }
}
~                                                                                                                                                                                              
~                  
