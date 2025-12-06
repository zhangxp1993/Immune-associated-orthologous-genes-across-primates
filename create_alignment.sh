./scripts/ortholog_toga.pl data/species_list data/human.longest.transcript.bed > orthogroup.txt
./scripts/orthofinder_findwantedOG_byspecies.pl orthogroup.txt
./scripts/orthofinder_findwantedOG_bylength.pl species_OrthologGroups.txt data/species_list data/human_hg38/toga.isoforms.tsv data/hg38_cds.fasta
for i in SingleCopyOrthologGroups/*fasta; do ./scripts/aln_cds2pep.pl $i ; done
./scripts/fastas2aligned_by_mafft_hamstr_version.pl pep_orthologGroup/ 28
./scripts/align2maxalign.pl pep_orthologGroup/ 28
./scripts/decide_maxalign.pl pep_orthologGroup/
./scripts/fastasOG2fasta.pl SingleCopyOrthologGroups/ OG_max.group
./scripts/remove_N_and_replacestopcodon_from_aln.pl cds_OrthologGroups/
./scripts/fastascds2protein.pl cds_OrthologGroups/ 10
./scripts/fastasalign_for_tecoffee.pl cds_OrthologGroups/ 28
./scripts/aligns_evaluate.pl cds_OrthologGroups/ 28
./scripts/pro2dna.replicates.pl cds_OrthologGroups/ 28
./scripts/pro2dna_trim.pl cds_OrthologGroups/ 24
./scripts/fastas2trimal.pl cds_aln/ 24
./scripts/merge_species_sequences.pl species_list
