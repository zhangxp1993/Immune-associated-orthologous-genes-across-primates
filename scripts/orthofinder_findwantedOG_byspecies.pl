#!/usr/bin/perl

my $usage = "Usage:\n\tperl findSingleCopyOrtholog.pl groups.txt\n";
die $usage if @ARGV == 0;

open GROUPFILE, $ARGV[0] or die $!;
open OUTPUT, '>', "species_OrthologGroups.txt" or die $!;
#mkdir "SingleCopyOrthologGroups" unless -e "SingleCopyOrthologGroups";

#open IN, "$ARGV[1]";
#while (<IN>){
#chomp;
#push @file, $_;}

#my (%fasta, @species);
#foreach $f (@file) {
#	my $species;
#	print STDERR "reading $_\n";
#	open IN, "$_/codonAlignments.fa" or die $!;
#	my $protein_id;
#	while (<IN>) {
#		chomp;
#		if (/>(\S+).*QUERY/) { $protein_id = $1; $n = 1;}
#		elsif($n == 1) {s/\s+//g; $fasta{$f}{$protein_id} .= $_; $length{$f}{$protein_id} = length($_); $n = 0;}
#	}
#	close IN;
#}

#my $species_num = @species;
#print STDERR "total $species_num species\n@species\n\n";

my $groupNum;
my ($spe, $num, $species, @seq,%species);
chomp($spe = <GROUPFILE>);
print OUTPUT "$spe\n";
$spe =~ s/^Orthogroup //;
my @species = split /\s/, $spe;
$num = scalar @species;

while (<GROUPFILE>) {
	undef %species;
	my $n = 0;
	my $t = 0;
	undef @seq;
	my $group = $1 if s/^([^:]+?):\s+?//;
	s/\s*$//;
	my @sequences = split /\s+/,$_;
	
	foreach (@sequences){
	/([^\s\|]+)\|/;
	push @seq, $_ if $1 ~~ @species;
	$species{$1} ++ if $1 ~~ @species;}
	
	@spe = keys %species;
#	print "@spe\n";
	$t = &cal_group(@spe);
#	print "$t\n";
	$nn ++ if $t == 0;	
	next if $t == 0;
#	$n_spe = scalar @spe;
#	next if $n_spe < $num - 5;

	foreach (keys %species){
	$n=1 if $species{$_} > 3;}
	$aa ++ if $n == 1;
	next if $n == 1;

	$groupNum ++;
	print OUTPUT  "$group: @seq\n";

#	open OUT, '>', "SingleCopyOrthologGroups/$group.fasta" or die $!;

#	foreach (@seq) {
#		/([^\s\|]+)\|(.*)/;
#		my $species = $1;
#		my $sequenceId = $2;
#		print OUT ">$species\|$sequenceId\n$fasta{$species}{$sequenceId}\n";
#	}
}

print STDERR "$groupNum groups of Single Copy Orthologs were found!\n";
#print STDERR "ALL the files were wrriten to SingleCopyOrthologGroups.txt and directory SingleCopyOrthologGroups\n";
print "$nn\n$aa\n";

sub cal_group{
@greap = ("Homo_sapiens","Pan_troglodytes","Pan_paniscus","Gorilla_gorilla","Pongo_abelii","Pongo_pygmaeus");
@gibbons = ("Nomascus_siki","Symphalangus_syndactylus","Hoolock_leuconedys","Hylobates_pileatus");
@cerco = ("Macaca_assamensis","Macaca_mulatta","Macaca_nemestrina","Macaca_silenus","Papio_anubis","Papio_hamadryas","Lophocebus_aterrimus","Theropithecus_gelada","Mandrillus_leucophaeus","Mandrillus_sphinx","Cercocebus_atys","Cercopithecus_albogularis","Cercopithecus_mona","Chlorocebus_aethiops","Chlorocebus_sabaeus","Erythrocebus_patas");
@colob = ("Trachypithecus_crepuscula","Pygathrix_nigripes","Rhinopithecus_roxellana","Rhinopithecus_strykeri","Piliocolobus_tephrosceles","Colobus_angolensis","Colobus_guereza");
@newpri = ("Callithrix_jacchus","Saguinus_midas","Aotus_nancymaae","Sapajus_apella","Cebus_albifrons","Ateles_geoffroyi","Pithecia_pithecia");
@single = ("Cephalopachus_bancanus");
@ayelem = ("Daubentonia_madagascariensis","Microcebus_murinus","Prolemur_simus","Lemur_catta");
@lorgal = ("Loris_tardigradus","Nycticebus_bengalensis","Nycticebus_pygmaeus","Galago_moholi","Otolemur_garnettii");
@outgroup = ("Galeopterus_variegatus","Tupaia_belangeri");

  $gr = 0; $gi = 0; $ce = 0; $co = 0; $ne = 0; $si = 0; $ay = 0; $lo = 0; $ou = 0; $mo = 0; $t = 0; 
foreach $s (@_){
  
  $gr ++ if $s ~~ @greap;
  $gi ++ if $s ~~ @gibbons;
  $ce ++ if $s ~~ @cerco;
  $co ++ if $s ~~ @colob;
  $ne ++ if $s ~~ @newpri;
  $si ++ if $s ~~ @single;
  $ay ++ if $s ~~ @ayelem;
  $lo ++ if $s ~~ @lorgal;
  $ou ++ if $s ~~ @outgroup;
  $mo ++ if $s eq "Mus_musculus";
}
  if ($gr >= 1 && $gi >= 1 && $ce >= 1 && $co >= 1 && $ne >= 1 && $si == 1 && $ay >= 1 && $lo >= 1 && $ou >= 1 && $mo == 1){$t = 1;}else{$t = 0;}
  return $t;  
}


