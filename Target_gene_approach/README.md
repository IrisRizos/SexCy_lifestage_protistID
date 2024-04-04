# File list


### Scripts:

1. Search for list of downloaded HMM profiles and parse HMM search output: HMM_search.sh, hmm_fasta_convert_SW.sh, hmm_graphics.sh

The script hmm_fasta_convert_SW.sh allows to convert alignements in stockholm format to fasta file. For that the use of easel miniapps implemented in HMMER is necessary (http://cryptogenomicon.org/extracting-hmmer-results-to-sequence-files-easel-miniapplications.html). This bash script also allows to recover the predicted number of proteins for each transcriptome. 

The second bash script (hmm_graphics.sh) recovers quality information relative to the hmm profile alignments and combines it with the output of the previous script. The final file of this script node_count_query_score_hits.csv, is the input for graphical representations.

Both scripts are run by life stage and are here applied to swarmer and meiosis transcriptome data, as an example.


2. Create lineage specific HMM profiles, search and parse: HMM_build.sh, HMM_search_linsp.sh, HMM_graphics_linsp.sh





3. Graphical visualisation: scRNA_paper_Acanth.Rmd, scRNA_paper_Acanth_suppl.Rmd (cf. homepage)


### Predicted proteomes:

Input of step 1.: (cf. Data)


### Dataframes:

* Input of step 1.: HMM_search_gamete_ref.hmm, HMM_search_meiosis_ref.hmm

* Input of step 2.: 

* Input of step 3.: 

* Input of step 4.: quants, annotation, node_count_query_score_hits_SW.csv, node_count_query_score_hits_CY.csv, node_count_query_score_hits_VE.csv, hmm_spA_noIso_expr6.csv


### Graphics:

* Fig2: plot of up-regulated ref genes, expression box-plots according to annotation

* FigSX: decision bubble plot cov and expression

