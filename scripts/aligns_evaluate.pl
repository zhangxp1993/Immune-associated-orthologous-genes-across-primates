#!/usr/bin/perl
use strict;
my $usage = <<USAGE;
Usage:
	perl $0 SingleCopyOrthologGroups 24[this is CPU threads]

USAGE
die $usage if @ARGV != 2;

my @files = `ls $ARGV[0]`;

open CMDS, '>', "evaluate_cmds" or die $!;

foreach (@files) {
	chomp;
	next unless m/(\S+)\.aln$/;
	print CMDS "t_coffee -infile $ARGV[0]/$_ -evaluate -output score_ascii\n";
}

close CMDS;

my $parafly_result =`ParaFly -c evaluate_cmds -CPU $ARGV[1] -shuffle -v`;


