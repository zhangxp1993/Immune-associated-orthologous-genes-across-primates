#!/usr/bin/perl
my $usage = <<USAGE;
Usage:
	perl $0 pep_seq_file hmm_result

USAGE
die $usage if @ARGV != 2;

my @files = `ls $ARGV[0]`;

open IN, "$ARGV[1]";
while (<IN>){
	undef @seq;
	chomp;
	$og = $1 if s/^(\S+):\s+//;
	@seq = split /\s+/;

	open IN1,"$ARGV[0]/$og.fasta";
	while (<IN1>){
	chomp;
	if (/>(\S+)/){$seq_id = $1;}else{
	$sequence{$seq_id} .= $_;}}
	close IN1;
	
	open OUT, ">$ARGV[0]/$og.mapped.fa";
	foreach (keys %sequence){
	if ($_ ~~ @seq){print OUT ">$_\n$sequence{$_}\n";}
	}
	close OUT;
}
#unlink "clustalo_cmds", "clustalo_cmds.completed" unless -e "FailedCommands";

