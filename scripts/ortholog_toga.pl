#!/usr/bin/perl
my $usage = <<USAGE;
Usage:
        perl $0 species_list longest_transcripts > output

USAGE
die $usage if @ARGV == 0;


open IN, "$ARGV[0]";
while (<IN>){
  chomp;
  push @file, $_;}

open IN1, "$ARGV[1]";
while (<IN1>){
  chomp;
  /^(\S+)/;
  push @t, $1;}

foreach $f (@file){
  open IN, "data/TOGA_results/$f/orthologsClassification.tsv";
  <IN>;
  while (<IN>){
	chomp;
	@l = split /\s+/;
	next unless $l[1] ~~ @t;
	next if /None/;
	$seq{$l[0]}{$f} .= "$f\|$l[3] ";
	}
  close IN;
}

$line = join(" ", @file);
print "Orthogroup Homo_sapiens $line\n";
$n = 0;
@seq = sort keys %seq;
foreach $s (@seq){
  undef $line;
  foreach $f (@file){
	if ($seq{$s}{$f}){
	$seq{$s}{$f} =~ s/ $//;
	$line .= "$seq{$s}{$f} ";}
}
  $n ++;
  $line =~ s/ $//;
  print "OG$n: Homo_sapiens\|$s $line\n";
}
