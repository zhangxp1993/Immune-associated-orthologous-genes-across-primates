#!/usr/bin/perl

open IN, "$ARGV[0]";

while (<IN>){
  chomp;
  @l = split /\t/;
  $w{$l[1]}{$l[0]} = $l[2];
  $og{$l[0]} = 1;
}

@og = sort keys %og;
$o = join("\t", @og);
print "Species\t$o\n";

foreach $s (sort keys %w){
  my $l;
  foreach $g (@og){ 
	if (exists $w{$s}{$g}){ $l .= "$w{$s}{$g}\t";}
	else {$l .= "NA\t";}
	}
  $l =~ s/\t$//;
  print "$s\t$l\n";
}
