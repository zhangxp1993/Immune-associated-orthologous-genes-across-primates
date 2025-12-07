#!/usr/bin/perl

my $usage = "Usage:\n\tperl findSingleCopyOrtholog.pl groups.txt species_list toga.isoforms.tsv hg38_cds.fasta\n";
die $usage if @ARGV == 0;

open GROUPFILE, $ARGV[0] or die $!;
open OUTPUT, '>', "length_OrthologGroups.txt" or die $!;
mkdir "SingleCopyOrthologGroups" unless -e "SingleCopyOrthologGroups";

open IN, "$ARGV[1]";
while (<IN>){
chomp;
push @file, $_;}

my (%fasta, @species);
foreach $f (@file) {
	my $species;
	print STDERR "reading $f\n";
	open IN, "data/TOGA_results/$f/codonAlignments.fa" or die $!;
	my $protein_id;
	while (<IN>) {
		chomp;
		if (/>(\S+).*QUERY/) { $protein_id = $1; $n = 1;}
		elsif($n == 1) {s/\s+//g; $fasta{$f}{$protein_id} .= $_; $n = 0;}
	}
	close IN;
}

open IN1, "$ARGV[2]";
<IN1>;
while (<IN1>){
	chomp;
	@l = split /\s+/;
	$id{$l[1]} = $l[0];}

open IN2, "$ARGV[3]";
while (<IN2>) {
       chomp;
       if (/^>(\S+)/) { $protein_id = $1;}
       else{$fasta{"Homo_sapiens"}{$id{$protein_id}} .= $_;}
}



my $groupNum;
my ($spe, $num, $species, @seq,%species);
chomp($spe = <GROUPFILE>);
print OUTPUT "$spe\n";
$spe =~ s/^Orthogroup //;
my @species = split /\s/, $spe;
$num = scalar @species;
#print @species;

while (<GROUPFILE>) {
	chomp;
	undef %seq;
	undef %species;
	my $n = 0;
	my $t = 0;
	undef @seq;
	my $group = $1 if s/^([^:]+?):\s+?//;
	s/\s*$//;
	my @sequences = split /\s+/,$_;
	
	foreach (@sequences){
	/([^\s\|]+)\|(\S+)/;
	$species{$1} ++ if $1 ~~ @species;
	$seq{$1} .= "$2\t";}

	foreach (sort keys %species){
	$seq{$_} =~ s/\t$//;
	if ($species{$_} == 1){push @seq, "$_\|$seq{$_}";}
	else {@l = split /\t/, $seq{$_}; 
	@sort_l = sort {length($fasta{$_}{$b}) <=> length($fasta{$_}{$a})} @l; 
	push @seq, "$_\|$sort_l[0]";}
}
	print OUTPUT  "$group: @seq\n";

	open OUT, '>', "SingleCopyOrthologGroups/$group.fasta" or die $!;

	foreach (@seq) {
		/([^\s\|]+)\|(.*)/;
		my $species = $1;
		my $sequenceId = $2;
		$sequence = $fasta{$species}{$sequenceId};
		$sequence =~ s/-//g;
		print OUT ">$species\|$sequenceId\n$sequence\n";
	}
}

print STDERR "$groupNum groups of Single Copy Orthologs were found!\n";
#print STDERR "ALL the files were wrriten to SingleCopyOrthologGroups.txt and directory SingleCopyOrthologGroups\n";


