#!/usr/bin/perl

foreach $f (<$ARGV[0]/*.mapped.fasta>){
	open IN, "$f" or die $!;
	open OUT, ">$f.tmp";
	while (<IN>) {
                chomp;
                if (/>(\S+)/) { $protein_id = $1; }
                else { $fasta{$protein_id} .= $_; }
        }
        close IN;
	foreach (keys %fasta){
	$seq = $fasta{$_};
	while ((length $seq) >= 3) {
        $seq =~ s/([\w|-]{3})//;
	$codon = $1;
	$codon =~ s/TAA|TAG|TGA//i;
        unless ($codon =~ /N|X/){$sequence .=$codon;}
    }

	print OUT ">$_\n$sequence\n";
	undef $sequence;
}
`mv $f.tmp $f`;
undef %fasta;
}

