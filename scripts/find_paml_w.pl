#!/usr/bin/perl

@hompan = ("Homo_sapiens","Pan_troglodytes","Pan_paniscus");
@pan = ("Pan_troglodytes","Pan_paniscus");
@pongo = ("Pongo_abelii","Pongo_pygmaeus");
@greap = ("Homo_sapiens","Pan_troglodytes","Pan_paniscus","Gorilla_gorilla");
@ape = ("Homo_sapiens","Pan_troglodytes","Pan_paniscus","Gorilla_gorilla","Pongo_abelii","Pongo_pygmaeus");
@gibbons = ("Nomascus_siki","Symphalangus_syndactylus","Hoolock_leuconedys","Hylobates_pileatus");
@cerco = ("Macaca_assamensis","Macaca_mulatta","Macaca_nemestrina","Macaca_silenus","Papio_anubis","Papio_hamadryas","Lophocebus_aterrimus","Theropithecus_gelada","Mandrillus_leucophaeus","Mandrillus_sphinx","Cercocebus_atys","Cercopithecus_albogularis","Cercopithecus_mona","Chlorocebus_aethiops","Chlorocebus_sabaeus","Erythrocebus_patas");
@colob = ("Trachypithecus_crepuscula","Pygathrix_nigripes","Rhinopithecus_roxellana","Rhinopithecus_strykeri","Piliocolobus_tephrosceles","Colobus_angolensis","Colobus_guereza");
@newpri = ("Callithrix_jacchus","Saguinus_midas","Aotus_nancymaae","Sapajus_apella","Cebus_albifrons","Ateles_geoffroyi","Pithecia_pithecia");
@single = ("Cephalopachus_bancanus");
@ayelem = ("Daubentonia_madagascariensis","Microcebus_murinus","Prolemur_simus","Lemur_catta");
@lorgal = ("Loris_tardigradus","Nycticebus_bengalensis","Nycticebus_pygmaeus","Galago_moholi","Otolemur_garnettii");
@outgroup = ("Galeopterus_variegatus","Tupaia_belangeri");
@gregib = (@ape,@gibbons);
@cercol = (@cerco,@colob);
@oldpri = (@ape,@gibbons,@colob,@cerco);
@highpri = (@oldpri,@newpri);
@yuan = (@ayelem,@lorgal);
@primate = (@highpri,@yuan);
@haplorrhini = (@highpri,@single);
@outfly = (@primate,"Galeopterus_variegatus");
@outtup = (@primate,@outgroup);

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

open OUT, ">>og_nodes_w" if $tree;
%spe = $tree =~ /([A-Za-z_]+)\s+#([\d\.]+)/g;
foreach (keys %spe){print OUT "$file\t$_\t$spe{$_}\n" if $_ eq "Homo_sapiens" || $_ eq "Gorilla_gorilla" || $_ eq "Cephalopachus_bancanus" || $_ eq "Galeopterus_variegatus" || $_ eq "Tupaia_belangeri";}
my $out = 0;
my $out = 1 if $tree =~ /Galeopterus_variegatus/;

foreach $s (@species){
  $n_greap ++ if $s ~~ @greap;
  $n_hompan ++ if $s ~~ @hompan;
  $n_pan ++ if $s ~~ @pan;
  $n_pongo ++ if $s ~~ @pongo;
  $n_ape ++ if $s ~~ @ape;
  $n_gibbons ++ if $s ~~ @gibbons;
  $n_cerco ++ if $s ~~ @cerco;
  $n_colob ++ if $s ~~ @colob;
  $n_newpri ++ if $s ~~ @newpri;
  $n_ayelem ++ if $s ~~ @ayelem;
  $n_lorgal ++ if $s ~~ @lorgal;
  $n_gregib ++ if $s ~~ @gregib;
  $n_cercol ++ if $s ~~ @cercol;
  $n_oldpri ++ if $s ~~ @oldpri;
  $n_highpri ++ if $s ~~ @highpri;
  $n_yuan ++ if $s ~~ @yuan;
  $n_primate ++ if $s ~~ @primate;
  $n_haplorrhini ++ if $s ~~ @haplorrhini;
  $n_outfly ++ if $s ~~ @outfly;
  $n_outtup ++ if $s ~~ @outtup;
}
foreach (@greap){$w_greap = $spe{$_} if $spe{$_};}
foreach (@hompan){$w_hompan = $spe{$_} if $spe{$_};}
foreach (@pan){$w_pan = $spe{$_} if $spe{$_};}
foreach (@pongo){$w_pongo = $spe{$_} if $spe{$_};}
foreach (@outfly){$w_outfly = $spe{$_} if $spe{$_};}
foreach (@ape){$w_ape = $spe{$_} if $spe{$_};}
foreach (@gibbons){$w_gibbons = $spe{$_} if $spe{$_};}
foreach (@cerco){$w_cerco = $spe{$_} if $spe{$_};}
foreach (@colob){$w_colob = $spe{$_} if $spe{$_};}
foreach (@newpri){$w_newpri = $spe{$_} if $spe{$_};}
foreach (@ayelem){$w_ayelem = $spe{$_} if $spe{$_};}
foreach (@lorgal){$w_lorgal = $spe{$_} if $spe{$_};}
foreach (@gregib){$w_gregib = $spe{$_} if $spe{$_};}
foreach (@cercol){$w_cercol = $spe{$_} if $spe{$_};}
foreach (@oldpri){$w_oldpri = $spe{$_} if $spe{$_};}
foreach (@highpri){$w_highpri = $spe{$_} if $spe{$_};}
foreach (@yuan){$w_yuan = $spe{$_} if $spe{$_};}
foreach (@primate){$w_primate = $spe{$_} if $spe{$_};}
foreach (@haplorrhini){$w_haplorrhini = $spe{$_} if $spe{$_};}
foreach (@outtup){$w_outtup = $spe{$_} if $spe{$_};}

$nodes = $tree =~ s/\)/\)/g;
$nodes = $nodes - 1;

foreach $no (1..$nodes) {
$tree =~ /((.*?\)){$no})\s*#([\d\.]+)/;
$l = $1;
$w_node{$no} = $3;
$n = $l =~ s/\(/\(/g;
foreach $i (1..$n){
  $line = $l;
  $ii = $n - $i + 1;
  $line =~ s/(.*?\(){$ii}/\(/;
  my $a = $line =~ s/\(/\(/g;
  my $b = $line =~ s/\)/\)/g;
  $name{$no} = $line if $a == $b;
#  print "$no\t$line\n" if $a == $b;
  last if $a == $b;
  }
}

foreach (sort {$a <=> $b} keys %name){
  @species = $name{$_} =~ /([A-Za-z_]+)/g;
  $num{$_} = scalar @species;
#  print "$name{$_}\n";
  undef $nn_greap; undef $nn_ape; undef $nn_hompan; undef $nn_gibbons; undef $nn_cerco; undef $nn_colob; undef $nn_newpri; undef $nn_ayelem; undef $nn_pan; undef $nn_pongo;
  undef $nn_lorgal; undef $nn_gregib; undef $nn_cercol; undef $nn_oldpri; undef $nn_highpri; undef $nn_yuan; undef $nn_primate; undef $nn_haplorrhini; undef $nn_outfly;undef $nn_outtup;
  foreach $s (@species){
  $nn_greap ++ if $s ~~ @greap;
  $nn_ape ++ if $s ~~ @ape;
  $nn_hompan ++ if $s ~~ @hompan;
  $nn_gibbons ++ if $s ~~ @gibbons;
  $nn_cerco ++ if $s ~~ @cerco;
  $nn_colob ++ if $s ~~ @colob;
  $nn_newpri ++ if $s ~~ @newpri;
  $nn_ayelem ++ if $s ~~ @ayelem;
  $nn_lorgal ++ if $s ~~ @lorgal;
  $nn_gregib ++ if $s ~~ @gregib;
  $nn_cercol ++ if $s ~~ @cercol;
  $nn_oldpri ++ if $s ~~ @oldpri;
  $nn_highpri ++ if $s ~~ @highpri;
  $nn_yuan ++ if $s ~~ @yuan;
  $nn_primate ++ if $s ~~ @primate;
  $nn_haplorrhini ++ if $s ~~ @haplorrhini;
  $nn_pan ++ if $s ~~ @pan;
  $nn_pongo ++ if $s ~~ @pongo;
  $nn_outfly ++ if $s ~~ @outfly;
  $nn_outtup ++ if $s ~~ @outtup;
}
  if ($nn_greap == $n_greap){push @node_greap, $_;}
  if ($nn_ape == $n_ape){push @node_ape, $_;}
  if ($nn_hompan == $n_hompan){push @node_hompan, $_;}
  if ($nn_gibbons == $n_gibbons){push @node_gibbons, $_;}
  if ($nn_cerco == $n_cerco){push @node_cerco, $_;}
  if ($nn_colob == $n_colob){push @node_colob, $_;}
  if ($nn_newpri == $n_newpri){push @node_newpri, $_;}
  if ($nn_ayelem == $n_ayelem){push @node_ayelem, $_;}
  if ($nn_lorgal == $n_lorgal){push @node_lorgal, $_;}
  if ($nn_gregib == $n_gregib){push @node_gregib, $_;}
  if ($nn_cercol == $n_cercol){push @node_cercol, $_;}
  if ($nn_oldpri == $n_oldpri){push @node_oldpri, $_;}
  if ($nn_highpri == $n_highpri){push @node_highpri, $_;}
  if ($nn_yuan == $n_yuan){push @node_yuan, $_;}
  if ($nn_primate == $n_primate){push @node_primate, $_;}
  if ($nn_haplorrhini == $n_haplorrhini){push @node_haplorrhini, $_;}
  if ($nn_pan == $n_pan){push @node_pan, $_;}
  if ($nn_pongo == $n_pongo){push @node_pongo, $_;}
  if ($nn_outfly == $n_outfly){push @node_outfly, $_;}
  if ($nn_outtup == $n_outtup){push @node_outtup, $_;}
}
@node_greap = sort {$num{$a} <=> $num{$b}} @node_greap;
@node_ape = sort {$num{$a} <=> $num{$b}} @node_ape;
@node_hompan = sort {$num{$a} <=> $num{$b}} @node_hompan;
@node_gibbons =  sort {$num{$a} <=> $num{$b}} @node_gibbons;
@node_cerco = sort {$num{$a} <=> $num{$b}} @node_cerco;
@node_colob = sort {$num{$a} <=> $num{$b}} @node_colob;
@node_newpri = sort {$num{$a} <=> $num{$b}} @node_newpri;
@nn_ayelem = sort {$num{$a} <=> $num{$b}} @node_ayelem;
@node_lorgal = sort {$num{$a} <=> $num{$b}} @node_lorgal;
@node_gregib = sort {$num{$a} <=> $num{$b}} @node_gregib;
@node_cercol = sort {$num{$a} <=> $num{$b}} @node_cercol;
@node_oldpri = sort {$num{$a} <=> $num{$b}} @node_oldpri;
@node_highpri = sort {$num{$a} <=> $num{$b}} @node_highpri;
@node_yuan = sort {$num{$a} <=> $num{$b}} @node_yuan;
@node_primate = sort {$num{$a} <=> $num{$b}} @node_primate;
@node_haplorrhini = sort {$num{$a} <=> $num{$b}} @node_haplorrhini;
@node_pan = sort {$num{$a} <=> $num{$b}} @node_pan;
@node_pongo = sort {$num{$a} <=> $num{$b}} @node_pongo;
@node_outfly = sort {$num{$a} <=> $num{$b}} @node_outfly;
@node_outtup = sort {$num{$a} <=> $num{$b}} @node_outtup;


if ($n_greap == 1){$greap = $w_greap;}else{$greap = $w_node{$node_greap[0]};}
if ($n_ape == 1){$ape = $w_ape;}else{$ape = $w_node{$node_ape[0]};}
if ($n_hompan == 1){$hompan = $w_hompan;}else{$hompan = $w_node{$node_hompan[0]};}
if ($n_gibbons == 1){$gibbons = $w_gibbons;}else{$gibbons = $w_node{$node_gibbons[0]};}
if ($n_cerco == 1){$cerco = $w_cerco;}else{$cerco = $w_node{$node_cerco[0]};}
if ($n_colob == 1){$colob = $w_colob;}else{$colob = $w_node{$node_colob[0]};}
if ($n_newpri == 1){$newpri = $w_newpri;}else{$newpri = $w_node{$node_newpri[0]};}
if ($n_ayelem == 1){$ayelem = $w_ayelem;}else{$ayelem = $w_node{$node_ayelem[0]};}
if ($n_lorgal == 1){$lorgal = $w_lorgal;}else{$lorgal = $w_node{$node_lorgal[0]};}
if ($n_gregib == 1){$gregib = $w_gregib;}else{$gregib = $w_node{$node_gregib[0]};}
if ($n_cercol == 1){$cercol = $w_cercol;}else{$cercol = $w_node{$node_cercol[0]};}
if ($n_oldpri == 1){$oldpri = $w_oldpri;}else{$oldpri = $w_node{$node_oldpri[0]};}
if ($n_highpri == 1){$highpri = $w_highpri;}else{$highpri = $w_node{$node_highpri[0]};}
if ($n_yuan == 1){$yuan = $w_yuan;}else{$yuan = $w_node{$node_yuan[0]};}
if ($n_primate == 1){$primate = $w_primate;}else{$primate = $w_node{$node_primate[0]};}
if ($n_haplorrhini == 1){$haplorrhini = $w_haplorrhini;}else{$haplorrhini = $w_node{$node_haplorrhini[0]};}
if ($n_pan == 1){$pan = $w_pan;}else{$pan = $w_node{$node_pan[0]};}
if ($n_pongo == 1){$pongo = $w_pongo;}else{$pongo = $w_node{$node_pongo[0]};}
if ($n_outfly == 1){$outfly = $w_outfly;}else{$outfly = $w_node{$node_outfly[0]};}
if ($n_outtup == 1){$outtup = $w_outtup;}else{$outtup = $w_node{$node_outtup[0]};}

if ($out == 1){$outclade = $outfly;}else{$outclade = $outtup;}

@species = ("Hom_pan","Great_Apes","Gorilla","Gibbons","Hominoidea","Monkeys","Old_World_Primates","New_World_Primates","Higher_Primates","Haplorrhini","Strepsirrhini","Primates","Pan","Pongo","Outclade");
@w = ($hompan,$ape,$greap,$gibbons,$gregib,$cercol,$oldpri,$newpri,$highpri,$haplorrhini,$yuan,$primate,$pan,$pongo,$outclade);

if ($tree){
	foreach (0..$#w){print OUT "$file\t$species[$_]\t$w[$_]\n";}
}

