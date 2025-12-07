#!/usr/bin/perl
use strict;
my $usage = <<USAGE;
Usage:
	perl $0 OrthologGroups 24[this is CPU threads]

USAGE
die $usage if @ARGV != 2;

my @files = `ls $ARGV[0]`;

open CMDS, '>', "trim_cmds" or die $!;

foreach (@files) {
	chomp;
	next unless m/(\S+)\.aln$/;
	print CMDS "trimal -in $ARGV[0]/$_ -out $ARGV[0]/$1.trim.aln -nogaps\n";
}

close CMDS;

my $parafly_result =`ParaFly -c trim_cmds -CPU $ARGV[1] -shuffle -v`;


