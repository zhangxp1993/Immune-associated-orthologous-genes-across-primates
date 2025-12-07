#!/usr/bin/perl
use strict;
my $usage = <<USAGE;
Usage:
	perl $0 cds_OrthologGroup 24[this is CPU threads]

USAGE
die $usage if @ARGV != 2;

my @files = `ls $ARGV[0]`;

open CMDS, '>', "dna_replicates_cmds" or die $!;

foreach (@files) {
	chomp;
	next unless m/(\S+)\.aln$/;
	print CMDS "t_coffee -other_pg seq_reformat -in $ARGV[0]/$_ -in2 $ARGV[0]/$1.fasta -struc_in $ARGV[0]/$1.score_ascii -struc_in_f number_aln -output tcs_replicate_100 -out $ARGV[0]/$1.dna.replicates\n";
}

close CMDS;

my $parafly_result =`ParaFly -c dna_replicates_cmds -CPU $ARGV[1] -shuffle -v`;


