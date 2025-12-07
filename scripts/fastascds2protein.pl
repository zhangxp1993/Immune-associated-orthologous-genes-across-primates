#!/usr/bin/perl
use strict;
my $usage = <<USAGE;
Usage:
	perl $0 cds_OrthologGroups 24[this is CPU threads]

USAGE
die $usage if @ARGV != 2;

my @files = `ls $ARGV[0]`;

open CMDS, '>', "translate_cmds" or die $!;

foreach (@files) {
	chomp;
	next unless m/(\S+)\.mapped\.fasta$/;
	print CMDS "t_coffee -other_pg seq_reformat -in $ARGV[0]/$_ -action +translate -output fasta_seq > $ARGV[0]/$1.mapped.aa \n";
}

close CMDS;

my $parafly_result =`ParaFly -c translate_cmds -CPU $ARGV[1] -shuffle -v`;


