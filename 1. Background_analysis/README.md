# File list

### Scripts:

1. Initial read quality check: quality.sh

2. Single-cell transcriptome assembly: rrnaspade.sh

3. Peptide prediction: transdec.sh

4. Compute read remapping rates on assembled genes (proxy for gene expression): remap_expr.sh (+kallisto ask Caro)

5. Functionnal annotations of predicted proteins: eggNOG_fun.sh

6. Graphical visualisation: scRNA_paper_Acanth.Rmd, scRNA_paper_Acanth_suppl.Rmd (cf. homepage)

7. Phylogenetic reconstruction based on 18S-28S: rrna_get.sh, phylogeny_AlignTrim.sh, phylogeny_raxML_ng_BS.sh, scRNA_paper_Acanth_suppl.Rmd (cf. homepage)


### Single-cell transcriptomes and predicted proteomes (biological data):

Input of step 1.: transcriptomes (cf. Data)

Input of step 2.: predicted proteomes (cf. Data)


### Dataframes (computational data): 

Input of step 3.: annotations.tsv, quants.csv

Input of step 4.: 18S.fasta, 28S.fasta, quants.csv

Input of step 7.: V4_sc_ref_31seq_Acanth.fasta


### Figures:

* Fig1B: phylogeny

* Fig1C: NMDS based on COG differential expression

* Fig1D: heatmap of COG expression in reproductive stages compared to vegetative

* FigSX: NMDS only Acantharia

* FigSX: expression of 18S and 28S

