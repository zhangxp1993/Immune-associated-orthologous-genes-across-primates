# Immune-associated-orthologous-genes-across-primates
We applied the TOGA pipeline to generate a robust catalog of one-to-one orthologous genes across 50 primate species and two closely related outgroups (Malayan flying lemur and Chinese tree shrew). Estimates of dN/dS for each branch of the primate phylogeny were then obtained for every gene using the free-ratio model implemented in PAML 4.9.

## bash_create_alignment.sh 
This script is used to generate the one-to-one orthologous gene catalog across the 50 primate species.
Example usage:
bash ./bash_create_alignment.sh. 
Note:
Before running this script, you must download the data folder from the following Dryad repository:
https://doi.org/10.5061/dryad.6q573n65z.

## bash_paml_mfree.sh
This script is used to calculate dN/dS values along each branch of the phylogeny using the free-ratio model from PAML 4.9.
Example usage:
bash ./bash_paml_mfree.sh.
Note:
Before running this script, you must first run bash_create_alignment.sh.

## Immunity.R
R scripts support downstream analyses such as phylogenetic generalized least squares (PGLS), hierarchical clustering. 

## Prerequisites
Linux\n
PAML 4.9

R version 4.2.0
nipals 0.8
UpSetR 1.4.0
ggplot2 3.5.1
phytools 2.1.1
caper 1.0.3
ggpubr 0.6.0
