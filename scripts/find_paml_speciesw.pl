#!/usr/bin/perl

open IN, "$ARGV[0]";
$ARGV[0] =~ /(OG\d+)/;
$file = $1;

while (<IN>){
  chomp;
  $json .= "$_";}

$json =~ /w ratios as labels for TreeView:\s*(.*?);/;
$tree = $1;
my @species = $tree =~ /(\w+)/g;
die if $tree =~ /#-nan/;

open OUT, ">>og_species_w_immune" if $tree;
%spe = $tree =~ /([A-Za-z_]+)\s+#([\d\.]+)/g;
foreach (keys %spe){print OUT "$file\t$_\t$spe{$_}\n";}


