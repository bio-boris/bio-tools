#!/usr/bin/env perl
use strict;
use File::Basename;
use Getopt::Long;
my $xgmml   ;
my $output_dir ;
my $al;
my $pid;
my $score;
my $min_length ;
my $max_length ;
my $output_dir ;
my $fasta;

my $usage = "
            --FILES--    
        
            -xgmml  = <Path To XGMML>
            -fasta  = <Path to Fasta>
            -dir    = <Output Directory>
            
            --CUTOFFS--

            -pid    = <Percent Identity>
            -score  = <Alignment Score>
            -al     = <Alignment Length>
            -min_length = <Minimum Length>
            -max_length = <Maximum Length>\n\n";
die $usage unless scalar @ARGV > 1;

GetOptions ("xgmml=s" => \$xgmml,    # numeric
    "dir=s"   => \$output_dir,      # string
    "al=i"  => \$al,
    "pid=i"  => \$pid,
    "score=i"  => \$score,
    "min_length=i"  => \$min_length,
    "max_length=i"  => \$max_length,
    "fasta=s" => $fasta
)  
    or die("Error in command line arguments\n");


mkdir($output_dir);
mkdir("$output_dir/unzip");
die "Input xgmml" unless -s $xgmml;
die "Input output directory ($output_dir)" unless -s "$output_dir";

my $filename = basename($xgmml);
#/home/groups/efi/est-precompute/data/pfam/family/transfer/xgmml/demultiplexed
my $xgmml_dir = dirname(dirname($xgmml));
#/home/groups/efi/est-precompute/data/pfam/family/transfer/xgmml
my $xfer_dir = dirname($xgmml_dir);
#/home/groups/efi/est-precompute/data/pfam/family/
my $family_dir = dirname($xfer_dir);
my $family = basename($family_dir);
if(not -s $fasta){
    print "Cannot find $fasta\n";
}
$fasta = "$xfer_dir/fasta/$family.fa.renamed";
die "Cannot find $fasta" unless -s $fasta;

#Unzip a file, if necessary
my $unzipped_xgmml = "$output_dir/unzip/$filename";
$unzipped_xgmml =~ s/\.gz$//g;

if(not $xgmml =~ /\.gz$/){
    system("gunzip -c $xgmml > $unzipped_xgmml");
    die "Cannot find $unzipped_xgmml" unless(-s $unzipped_xgmml);
}
else{
    $unzipped_xgmml = $xgmml;
}



open F, $fasta or die $! . "Cannot find fasta";
my %length;
my $header;
while(my $line=<F>){
    chomp $line;
    if(substr($line,0,1) eq ">"){
        $header = substr($line,1); 
    }
    else{
        $length{$header} += length $line;
    }
}
close F;






open F, $unzipped_xgmml or die $!;
my $output = "$output_dir/$filename";
$output =~ s/\.gz$//g;
my $dropped =0;

open O, ">$output" or die $!;
my @edge;
my $in_edge=0;
my $count=0;
my $edgec=0;

while(my $line = <F>){
    if($in_edge){
        $count--;
        push @edge, $line;
        if($count ==1){
            $in_edge = 0;
            process_edge(@edge);
        }
    }
    else{
        if($line =~ /<edge id=/){
            $edgec++;
            @edge = ();
            push @edge, $line;
            $count = 5;
            $in_edge=1;
        }
        else{
            print O $line;
        }
    }

}
close F;
close O;

#Zip it


#<edge id="A0A068RF12,A0A077WTZ8" label="A0A068RF12,A0A077WTZ8" source="A0A068RF12" target="A0A077WTZ8">
#    <att name="%id" type="real" value="81.43" />
#        <att name="-log10(E)" type="real" value="114" />
#            <att name="alignment_len" type="integer" value="237" />
#              </edge>
my %count;
my $counts;
sub process_edge{
    $counts++;
    my @id_line = split /"/, $_[0];
    my $id1 = $id_line[5];
    my $id2 = $id_line[7];
    my $id = (split /"/, $_[1])[5];
    my $expect = (split /"/, $_[2])[5];
    my $length = (split /"/, $_[3])[5];

    $dropped++;
    if($id < $pid){

        $count{'pid'}++;
        # print STDERR "pid\n";
        return 0;
    }

    if($expect < $score){
        $count{'expect'}++;
        # print STDERR "expect\n";
        return 0;
    }
    if($length < $al){
        $count{'al'}++;
        # print STDERR "al\n";
        return 0;
    }

    if(defined $min_length && $min_length > 0){
        if($length{$id1} < $min_length || $length{$id2} < $min_length){
            $count{'min'}++;
            #   print STDERR "min\n";
            return 0;
        }
    }
    if(defined $max_length && $max_length > 0){
        if($length{$id1} > $max_length || $length{$id2} > $max_length){
            $count{'max'}++;
            # print STDERR "max\n";
            return 0;
        }
    }
    $dropped--;
    print O @_;
    return 1;
}

print "Dropped $dropped\n";;
foreach my $c(keys %count){
    print "$c\t$count{$c}\n";
}


#while(<F>){
#    #Just encountered an edge
#     if($_ =~/<edge id=/){
#       $in_edge = 1;
#        $edgec++;
#        push @edge, $_;
#        next;
#    }
#    if($_ =~/<\/edge>/){
#        my $r = process_edge(@edge);
#        print "$edgec [$r]\n"; 
#        $in_edge =0;
#        @edge = ();
#        next;
#    }
#    if($in_edge){
#        push @edge, $_;
#    }
#    elsif($in_edge ==0){
#        print O $_;
#    }
#}

