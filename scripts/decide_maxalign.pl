#!/usr/bin/perl
my $usage = <<USAGE;
Usage:
	perl $0 pep_maxalign

USAGE
die $usage if @ARGV == 0;

my @files = `ls $ARGV[0]`;

foreach (@files) {
	chomp;
	next unless m/(\S+)\.fasta$/;
	$f = "$1".'heuristic_exclude_headers.txt';
	$og = $1;
	undef @seqID;
	undef @d_max;
	undef @real;
	open IN1, "$ARGV[0]/$_" or die $!;
	while (<IN1>){
	  chomp;
	  if (/>(.*)/){push @seqID, $1;}
}
	$o_species = join("\t", @seqID);
	open IN2, "$ARGV[0]/$f" or die $!;
	while (<IN2>){
	  chomp;
	  push @d_max, $_;
}
	$d_species = join("\t",@d_max);
	@delete = &cal_group($o_species, $d_species);
	open OUT, ">$ARGV[0]/$og.deleteid";
	foreach $d (@delete){print OUT "$d\n";}
	close OUT;
	open OUT, ">>$ARGV[0]/OG_max.group";
	foreach (@seqID){
	  /(\S+)\|/;
	  push @real, $_ unless $1 ~~ @delete;}
	$l = join("\t", @real);
	print OUT "$og:\t$l\n";
	 
}


sub cal_group{
@greap = ("Homo_sapiens","Pan_troglodytes","Pan_paniscus","Gorilla_gorilla","Pongo_abelii","Pongo_pygmaeus");
@gibbons = ("Nomascus_siki","Symphalangus_syndactylus","Hoolock_leuconedys","Hylobates_pileatus");
@cerco = ("Macaca_assamensis","Macaca_mulatta","Macaca_nemestrina","Macaca_silenus","Papio_anubis","Papio_hamadryas","Lophocebus_aterrimus","Theropithecus_gelada","Mandrillus_leucophaeus","Mandrillus_sphinx","Cercocebus_atys","Cercopithecus_albogularis","Cercopithecus_mona","Chlorocebus_aethiops","Chlorocebus_sabaeus","Erythrocebus_patas");
@colob = ("Trachypithecus_crepuscula","Pygathrix_nigripes","Rhinopithecus_roxellana","Rhinopithecus_strykeri","Piliocolobus_tephrosceles","Colobus_angolensis","Colobus_guereza");
@newpri = ("Callithrix_jacchus","Saguinus_midas","Aotus_nancymaae","Sapajus_apella","Cebus_albifrons","Ateles_geoffroyi","Pithecia_pithecia");
@ayelem = ("Daubentonia_madagascariensis","Microcebus_murinus","Prolemur_simus","Lemur_catta");
@lorgal = ("Loris_tardigradus","Nycticebus_bengalensis","Nycticebus_pygmaeus","Galago_moholi","Otolemur_garnettii");
$o_species = shift @_;
$d_species = shift @_;
@o = $o_species =~ /(\S+)\|/g;
@d = $d_species =~ /(\S+)\|/g;
undef @delete;
$gr = 0; $gi = 0; $ce = 0; $co = 0; $ne = 0; $ay = 0; $lo = 0;
foreach $s (@o){
  
  $gr ++ if $s ~~ @greap;
  $gi ++ if $s ~~ @gibbons;
  $ce ++ if $s ~~ @cerco;
  $co ++ if $s ~~ @colob;
  $ne ++ if $s ~~ @newpri;
  $ay ++ if $s ~~ @ayelem;
  $lo ++ if $s ~~ @lorgal;
}
foreach $s (@d){
  next if $s eq "Homo_sapiens";
  next if $s eq "Galeopterus_variegatus";
  next if $s eq "Tupaia_belangeri";
  next if $s eq "Mus_musculus";
  next if $s eq "Cephalopachus_bancanus";
  $gr-- if $s ~~ @greap; 
  $gi-- if $s ~~ @gibbons;
  $ce-- if $s ~~ @cerco;
  $co-- if $s ~~ @colob;
  $ne-- if $s ~~ @newpri;
  $ay-- if $s ~~ @ayelem;
  $lo-- if $s ~~ @lorgal;
if ($gr >= 2 && $gi >= 2 && $ce >= 2 && $co >= 2 && $ne >= 2 && $ay >= 2 && $lo >= 2){push @delete, $s;}
else{
  $gr ++ if $s ~~ @greap;
  $gi ++ if $s ~~ @gibbons;
  $ce ++ if $s ~~ @cerco;
  $co ++ if $s ~~ @colob;
  $ne ++ if $s ~~ @newpri;
  $ay ++ if $s ~~ @ayelem;
  $lo ++ if $s ~~ @lorgal;}
}
  return @delete;
}



