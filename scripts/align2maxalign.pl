#!/usr/bin/perl
use strict;
my $usage = <<USAGE;
Usage:
	perl $0 cds_aln 24[this is CPU threads]

USAGE
die $usage if @ARGV != 2;

my @files = `ls $ARGV[0]`;

open CMDS, '>', "maxalign_cmds" or die $!;

foreach (@files) {
	chomp;
	next unless m/(\S+)\.aln$/;
	print CMDS "~/scripts/maxalign.pl -f=$ARGV[0]/$1 $ARGV[0]/$_\n";
}

close CMDS;

my $parafly_result =`ParaFly -c maxalign_cmds -CPU $ARGV[1] -shuffle -v`;

#unlink "clustalo_cmds", "clustalo_cmds.completed" unless -e "FailedCommands";

