./ortholog_toga.pl file ../../03_toga/for_merge/human.longest.transcript.bed > orthogroup.txt
./orthofinder_findwantedOG_byspecies.pl orthogroup.txt
./orthofinder_findwantedOG_bylength.pl species_OrthologGroups.txt file ~/opt/biosoft/TOGA-1.1.0/TOGAInput/human_hg38/toga.isoforms.tsv ../for_merge/hg38_cds.fasta
for i in SingleCopyOrthologGroups/*fasta; do ./aln_cds2pep.pl $i ; done
~/opt/scripts/fastas2aligned_by_mafft_hamstr_version.pl pep_orthologGroup/ 28
~/scripts/align2maxalign.pl pep_orthologGroup/ 28
./decide_maxalign.pl pep_orthologGroup/
~/scripts/fastasOG2fasta.pl SingleCopyOrthologGroups/ OG_max.group
~/scripts/remove_N_and_replacestopcodon_from_aln.pl cds_OrthologGroups/
~/scripts/fastascds2protein.pl cds_OrthologGroups/ 10
~/scripts/fastasalign_for_tecoffee.pl cds_OrthologGroups/ 28
~/scripts/aligns_evaluate.pl cds_OrthologGroups/ 28
~/scripts/pro2dna.replicates.pl cds_OrthologGroups/ 28
~/scripts/pro2dna_trim.pl cds_OrthologGroups/ 24
~/scripts/fastas2trimal.pl cds_aln/ 24
./OG2length.pl pep_orthologGroup/ > OG_pep_len
./merge_species_sequences.pl species_list
