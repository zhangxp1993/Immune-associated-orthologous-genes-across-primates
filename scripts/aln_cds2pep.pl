#!/usr/bin/perl

`mkdir pep_orthologGroup`;
open IN, "$ARGV[0]" or die $!;
open OUT, ">pep_orthologGroup/$ARGV[0]";
while (<IN>) {
               chomp;
               if (/>(.*)/) { $protein_id = $1; push @id, $1;}
               else { $fasta{$protein_id} .= $_; }
        }
        close IN;

	foreach (@id){
	$seq = $fasta{$_};
	my $pep_seq = &cds2pep($seq, $_);

	print OUT ">$_\n$pep_seq\n";
	undef $pep_seq;
}


sub cds2pep {
    my %cds2pep = (
        "TTT" => "F",
        "TTC" => "F",
        "TTA" => "L",
        "TTG" => "L",
        "TCT" => "S",
        "TCC" => "S",
        "TCA" => "S",
        "TCG" => "S",
        "TAT" => "Y",
        "TAC" => "Y",
        "TAA" => "X",
        "TAG" => "X",
        "TGT" => "C",
        "TGC" => "C",
        "TGA" => "X",
        "TGG" => "W",
        "CTT" => "L",
        "CTC" => "L",
        "CTA" => "L",
        "CTG" => "L",
        "CCT" => "P",
        "CCC" => "P",
        "CCA" => "P",
        "CCG" => "P",
        "CAT" => "H",
        "CAC" => "H",
        "CAA" => "Q",
        "CAG" => "Q",
        "CGT" => "R",
        "CGC" => "R",
        "CGA" => "R",
        "CGG" => "R",
        "ATT" => "I",
        "ATC" => "I",
        "ATA" => "I",
        "ATG" => "M",
        "ACT" => "T",
        "ACC" => "T",
        "ACA" => "T",
        "ACG" => "T",
        "AAT" => "N",
        "AAC" => "N",
        "AAA" => "K",
        "AAG" => "K",
        "AGT" => "S",
        "AGC" => "S",
        "AGA" => "R",
        "AGG" => "R",
        "GTT" => "V",
        "GTC" => "V",
        "GTA" => "V",
        "GTG" => "V",
        "GCT" => "A",
        "GCC" => "A",
        "GCA" => "A",
        "GCG" => "A",
        "GAT" => "D",
        "GAC" => "D",
        "GAA" => "E",
        "GAG" => "E",
        "GGT" => "G",
        "GGC" => "G",
        "GGA" => "G",
        "GGG" => "G",
	"XXX" => "X",
    );
    my $seq = shift @_;
    my $gene = shift @_;
    my $pep;
    while ((length $seq) >= 3) {
        $seq =~ s/(\S{3})//;
	if ($cds2pep{$1}){
        $pep .= $cds2pep{$1};}else{$pep .= "X";}
    }
    #print STDERR "Warning: CDS length of $gene is not multiple of 3\n" if (length $seq) > 0;
    #print STDERR "Warning: Stop Codon appear in the middle of $gene\n" if $pep =~ m/\*\w/;
    return $pep;
}
