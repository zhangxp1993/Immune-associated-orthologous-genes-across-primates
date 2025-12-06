#!/bin/bash
if [ -f "command_free_sh" ];then
 rm -f command_free_sh
fi
ls cds_aln/*aln > og
cat og | while read idd
do
id=${idd#*/}
mkdir paml_result/${id%.aln} -p
cp ./data/mfree_ctl paml_result/${id%.aln}
cp ./cds_aln/${id} paml_result/${id%.aln}
cp ./data/Primate_genome.nwk paml_result/${id%.aln}/tree.file
echo "cd paml_result/${id%.aln} && codeml mfree_ctl" >> command_free_sh
done
ParaFly -c xaa -CPU 28

for i in $(cat data/free_immune); do ./scripts/find_paml_w.pl $i ; done
for i in $(cat data/free_immune); do ./scripts/find_paml_speciesw.pl $i ; done
./scripts/w2pca.pl og_nodes_w > og_nodes_pca
./scripts/w2pca.pl og_species_w_immune > og_species_pca
