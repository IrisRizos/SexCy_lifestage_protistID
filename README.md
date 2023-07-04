# How to identify sexual cycle cues among uncultivable protists ?


From a genetic point of view, sexual processes seem to have arosen early in the evolution of eukaryotes and be widespread, even though observations of such mechanisms among protists are scarce (Speijer et al. 2015, Goodenough & Heitman 2014). The molecular basis of sexuality is linked to 2 cellular mechanisms: meiotic division (i.e. reduction of cell ploidy) and gamete fusion (i.e. restoration of cell ploidy to pre-meiotic stages) (Speijer et al. 2015, Goodenough & Heitman 2014).

For Rhizaria that are a tedious lineage to cultivate, genetic cues can help understand the reproductive mechanisms involved in their mysterious life cycle. Sexual reproduction has been observed among some cultivable rhizarian lineages (e.g. Phytomyxea and benthic Foraminifera) but remains enigmatic for Radiolaria. The existence of a sexual cycle has long been speculated, notably by Schewiakoff ~100 years ago. Since then, the lifespan, ploidy and role of each radiolarian life stage observed on the field remain to be resolved.

The present github includes the code for identifying reference protist genes specific to gamete and meiotic life stages based on single-cell transcriptomes of Radiolaria.

![Graphical](Fig1_A.png)

## Methods

### 1. Target-gene approach

#### 1.1 Functional annotation tools: 
EggNog, Interproscan


#### 1.2 HMM profile search: 

* Step 1: 

Align hmm profiles against predicted peptidome data: HMM_search.sh

````
#!/bin/sh
#
#SBATCH --job-name hmmsearch
#SBATCH --cpus-per-task=4
#SBATCH -o o.hmmS
#SBATCH -e e.hmmS
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Load module
module load hmmer/3.3.2

# Date of analysis
today=$(date +%F)

# Reference HMM profiles files
HMM_G="HMM_search_gamete_ref.hmm"
HMM_M="HMM_search_meiosis_ref.hmm"

# Run by life stage
# ${f##*/} allows to remove f extension and keep filename only

for f in /shared/projects/rhizaria_ref/Sexual_cycle/adult/*/*;
do
    hmmsearch -A adult/hmm_gamete_${f##*/}_${today}.sto -o adult/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout adult/hmm_gamete_${f##*/}_${today}.tsv $HMM_G ${f} 
    hmmsearch -A adult/hmm_meiosis_${f##*/}_${today}.sto -o adult/hmm_meiosis_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout adult/hmm_meiosis_${f##*/}_${today}.tsv $HMM_M ${f} 
done

for f in /shared/projects/rhizaria_ref/Sexual_cycle/meiosis_swarmer/*/*;
do
    hmmsearch -A swarmer/hmm_gamete_${f##*/}_${today}.sto -o swarmer/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout swarmer/hmm_gamete_${f##*/}_${today}.tsv $HMM_G ${f} 
    hmmsearch -A swarmer/hmm_meiosis_${f##*/}_${today}.sto -o swarmer/hmm_meiosis_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout swarmer/hmm_meiosis_${f##*/}_${today}.tsv $HMM_M ${f} 
done

for f in /shared/projects/rhizaria_ref/Sexual_cycle/cyst/*;
do
    hmmsearch -A adult/hmm_gamete_${f##*/}_${today}.sto -o adult/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout cyst/hmm_gamete_${f##*/}_${today}.tsv $HMM_G ${f} 
    hmmsearch -A adult/hmm_meiosis_${f##*/}_${today}.sto -o adult/hmm_meiosis_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout cyst/hmm_meiosis_${f##*/}_${today}.tsv $HMM_M ${f} 
done
##

````

* Step 2: 

Transcripts blasting with query domains were recovered in fasta files: hmm_fasta_convert_{lifestage}.sh

Headers of the fasta sequences contain the query id with which the domains significantly blasted (eval < 0.001) and the transcriptome id of the alignment.

The following script allows to convert alignements in stockholm format to the fasta file described above.
For that the use of easel miniapps implemented in HMMER is necessary (http://cryptogenomicon.org/extracting-hmmer-results-to-sequence-files-easel-miniapplications.html).

This script is applied to swarmer and meiosis transcriptome data. The equivalent script is applied to each life stage (cyst and vegetative) by changing the working directory.

````
#!/bin/sh
#
#SBATCH --job-name hmm_fasta
#SBATCH --cpus-per-task=2
#SBATCH -o o.hmm_convert
#SBATCH -e e.hmm_convert
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

module load hmmer/3.3.2

# For every stockholm generated file of significant alignmnets: get target sequences in fasta
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.sto;
do
   esl-reformat -o fasta_files/node_${f##*/}.fasta fasta ${f}
done

# Change file extensions
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/*.sto.fasta;
do 
   cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/
   mv "$f" "$(basename "$f" .sto.fasta).txt.fasta"
done

# Add query id to each target sequence significantly aligned (to its query)
cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv;
do
# Parse tsv to get node and query id
   sed 's/  */ /g' ${f} | awk -F " " '/^N/ {print$1";"$4}' | uniq > node_${f##*/}.txt
done

# Change file extensions
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv.txt;
do 
   mv "$f" "$(basename "$f" .tsv.txt).txt"
done

# Print query in front of corresponding node id of fasta file
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/node_*.txt;
do
   echo "looping 1 "${f##*/}""
   for i in $(cat ${f});
   do
      echo "im in the loop 2"
      node=$(echo $i | cut -d';' -f1)
      echo "$node"
      query=$(echo $i | cut -d';' -f2)
      echo "$query"
      cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/
      awk -v var1="$node" -v var2="$query" -F "/" '/^>/ {print $1"/"var1"/"var2"/"} ; !/^>/ {print $0}' ${f##*/}.fasta | tr -d "\n" | sed 's/>/\n/g' | awk -F "/" '{if ($1==$2) {print ">"$3"/"$2"\n"$4}}' >> query_${f##*/}.fasta
   done
done

# Add transcriptome id in header of each sequence
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/query_*.txt.fasta;
do
   id_name=$(echo "${f##*/}")
   echo "$id_name"
   sed 's/>\///g' ${f} | sed '/^$/d' | awk -v name="$id_name" '/^>/ {print$0"/"name} ; !/^>/ {print$0}' | sed 's/\/>/\//g' | sed 's/.txt.fasta//g' > final_${f##*/}
done
##
````

* Step 3: 

After the fasta sequences have been gathered, they are reorganised by query protein id: fasta_folders_{lifestage}.sh

Transcripts from different transcriptomes and life stages are grouped together based on the meiosis and gamete query ids with the following script:

````
#!/bin/sh
#
#SBATCH --job-name fasta_by_id
#SBATCH --cpus-per-task=2
#SBATCH -o o.fasta
#SBATCH -e e.fasta
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Create separate folders for storing transcripts by hmm query
# Gamete queries
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/final*.fasta;
do
   echo "looping 1 "${f##*/}""
   for i in $(cat gamete_query_ids.txt);
    do
      echo "im in the loop 2"
      query=$(echo $i | cut -f1)
      echo "$query"
      tr -d "\n" < ${f} | sed 's/-08/-08\//g' | sed 's/>/\n>/g' | awk -v var1="$query" '/^>/ {print ">"var1"/"$0}' | awk -F "/" '{if ($1==$2) {print $2"/"$3"/"$4"\n"$5}}' >> gamete_folder_id/${query}_SW.fasta
   done
done

# Meiosis queries
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/final*.fasta;
do
   echo "looping 1 "${f##*/}""
   for i in $(cat meiosis_query_ids.txt);
    do
      echo "im in the loop 2"
      query=$(echo $i | cut -f1)
      echo "$query"
      tr -d "\n" < ${f} | sed 's/-08/-08\//g' | sed 's/>/\n>/g' | awk -v var1="$query" '/^>/ {print ">"var1"/"$0}' | awk -F "/" '{if ($1==$2) {print $2"/"$3"/"$4"\n"$5}}' >> meiosis_folder_id/${query}_SW.fasta
   done
done
##
````

These output files are the basis of multiple sequence alignments and phylogenetic gene trees reconstructions (cf. 2.2).

*Step 4: 

File parsing and combination in order to produce the graphical output of the analysis in R (cf. Scripts).

The first bash script allows to recover the predicted number of proteins for each transcriptome.

````
#!/bin/sh
#
#SBATCH --job-name bash
#SBATCH --cpus-per-task=2
#SBATCH -o o.bash
#SBATCH -e e.bash
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Get number of predicted genes for each transcriptome
# Swarmer
for f in /shared/projects/rhizaria_ref/Sexual_cycle/meiosis_swarmer/*/*;
do
   nb_node=$(echo | grep -c ">" ${f})
   echo "$nb_node;${f##*/}" >> /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/graphics/node_count_MESW.csv
done

# Cyst
for f in /shared/projects/rhizaria_ref/Sexual_cycle/cyst/*;
do
   nb_node=$(echo | grep -c ">" ${f})
   echo "$nb_node;${f##*/}" >> /shared/projects/swarmer_radiolaria/finalresult/HMM/cyst/graphics/node_count_CY.csv
done

# Adult
for f in /shared/projects/rhizaria_ref/Sexual_cycle/adult/*/*;
do
   nb_node=$(echo | grep -c ">" ${f})
   echo "$nb_node;${f##*/}" >> /shared/projects/swarmer_radiolaria/finalresult/HMM/adult/graphics/node_count_VE.csv
done
##
````

The second bash script recovers quality information relative to the hmm profile alignments and combines it with the output of the previous script.
The final file of this script node_count_query_score_hits.csv, is the input for graphical representations.

The script is run by lifestage. The example bellow runs on swarmer lifestages.

````
#!/bin/sh
#
#SBATCH --job-name bash
#SBATCH --cpus-per-task=2
#SBATCH -o o.bash2
#SBATCH -e e.bash2
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Gather additional data of HMM output:
# Add query id to each target sequence significantly aligned (to its query) and alignement score
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv;
do
   id_name=$(echo "${f##*/}")
   echo "$id_name"
   refpr=$(echo $id_name | cut -d'_' -f2)
   echo "$refpr"
   sed 's/  */ /g' ${f} | awk -v name="$id_name" -v ref="$refpr" -F " " '/^N/ {print$1";"$4";"$7";"$8";"$22";"name";swarmer;"($17-$16+1)/$6";"ref}' | sed 's/(+),score=//g' | sed 's/(-),score=//g' | uniq >> node_query_score.csv
done

awk -F";" '$6 ~/soft/ || $6 ~/S/ {print$0";S"} ; $6 !~/soft/ && $6 !~/S/ && $6 !~/hf/ && $6 !~/H/ && $6 !~/hard/ {print$0";T"} ; $6 ~/hard/ || $6 ~/H/ || $6 ~/hf/ {print$0";H"}' node_query_score.csv > node_query_score_2.csv
awk -F";" '$6 ~/hf44/ {print$0";A1_Vi_SW"} ; $6 ~/hf45/ {print$0";A2_Vi_SW"} ; $6 ~/hf46/ {print$0";A3_Vi_SW"} ; $6 ~/E561/ {print$0";A4_Vi_CY"} ; $6 ~/E587/ {print$0";A2_Vi_CY"} ; $6 ~/M345/ {print$0";F1_Mo_MESW"}  ; $6 ~/M357/ {print$0";C1_Mo_SW"} ; $6 ~/M380/ {print$0";A5_Mo_ME"} ; $6 ~/SP22/ {print$0";A5_Vi_ME"}' node_query_score_2.csv > node_query_score_3.csv
awk -F";" '{OFS = FS} $11 ~/ME/ {$7="meiosis"} ; {print$0}' node_query_score_3.csv > node_query_score_4.csv

   # Count number of hits per reference, meiosis
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv;
do
cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/
echo "looping 1 "${f##*/}""
   for i in $(cat meiosis_query_ids.txt);
    do
      echo "im in the loop 2, $i"
      hits=$(echo | grep -c "$i" ${f})
      echo "$i;${f##*/};$hits" >> ../graphics/meiosis_query_counts.csv
   done
      # Count number of hits per reference, gamete
   echo "looping 1 "${f##*/}""
   for i in $(cat gamete_query_ids.txt);
    do
      echo "im in the loop 2, $i"
      hits=$(echo | grep -c "$i" ${f})
      echo "$i;${f##*/};$hits" >> ../graphics/gamete_query_counts.csv
   done
done

# Remove null counts
cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/graphics/
grep -F -v ";0" meiosis_query_counts.csv > meiosis_query_counts2.csv && mv meiosis_query_counts2.csv meiosis_query_counts.csv 
grep -F -v ";0" gamete_query_counts.csv > gamete_query_counts2.csv && mv gamete_query_counts2.csv gamete_query_counts.csv 

for i in $(cat gamete_query_counts.csv);
do
  echo "$i"
  target=$(echo "$i" | cut -d';' -f2)
  hits=$(echo "$i" | cut -d';' -f3)
  pr=$(echo "$i" | cut -d';' -f1)
  echo "$target;$hits;$pr"
  awk -v tar="$target" -v hit="$hits" -v prot="$pr" -F";" '$6==tar && $2==prot {print$0";"hit}' node_query_score_4.csv >> node_query_score_hits.csv
done

for i in $(cat meiosis_query_counts.csv);
do
  echo "$i"
  target=$(echo "$i" | cut -d';' -f2)
  hits=$(echo "$i" | cut -d';' -f3)
  pr=$(echo "$i" | cut -d';' -f1)
  echo "$target;$hits;$pr"
  awk -v tar="$target" -v hit="$hits" -v prot="$pr" -F";" '$6==tar && $2==prot {print$0";"hit}' node_query_score_4.csv >> node_query_score_hits.csv
done

# Add nb of nodes in each transcriptome
for i in $(cat node_count_MESW.csv);
do 
  echo "$i"
  count=$(echo "$i" | cut -d';' -f1)
  target=$(echo "$i" | cut -d';' -f2)
  echo "$target;$count"
  awk -v targ="$target" -v nb="$count" -F";" '$6~targ {print$0";"nb}' node_query_score_hits.csv >> node_count_query_score_hits.csv
done
##
````

#### 1.3 Target gene validation: 
-Interproscan

-Add resolution to analysis by blasting the HMM PFAMs to sequences according to various models with myCLADE: http://www.lcqb.upmc.fr/myclade/ 

-Check if sequences contain expected transmembrane domains with TMHMM


#### 1.4 Place the validated reproductive genes in an evolutionary context: 
Calculate genes trees and compare to species tree.


### 2. Comparative approach

#### 2.1 Creating clusters of ortholog genes:
Orthofinder


#### 2.2 Phylogenetic relationships of sexual genes:
Are the gene trees and species tree congruent ?



## Reference protist genes

Gamete related genes= 11 (cf. table X)
CFA20, MAC-A, HAP2-GCS1, FUS1, GEX2, KAR5, Fus2, MATa1, SAM, MatA, CFA20

among which 10 gamete specific = all except CFA20

Meiosis related = 32 (35 domains)
among which 11 meiosis specific = REC8, HOP1, SPO22, PCH2, SPO11, HOP2, MND1, DMC1, MSH4, MSH5, MER3



## Life stages

The radiolarian life stages studied here are:

-Swarmer: hypothetical gamete stage 
The expression of gamete reference genes is investigated among 4 single-cell swarmer transcriptomes of 3 acantharian and 1 collodarian species.

-Meiosis: stage before swarmer release, morphologically identifiable by a change of color, size, shape and granulosity of the cell 

Two types of meiosis stages are supposed to apply to Radiolaria according to the modality of swarmer release:

*Vegetative swarming*: the overall shape of the cell remains the same while swarmers emerge from the cytoplasm

Samples include 1 acantharian, 1 spumellarian and 1 foraminiferan species.

*Cyst swarming*: the cell forms a dense and opaque round-shaped structure from which swarmer emerge either through a pore or the periphery of the cyst

Samples include 2 acantharian species among which one also undergone vegetative swarming (i.e. one of the acantharian swarmer samples).

Both the expression of meiosis and gamete reference genes is investigated as the presence of swarmers inside the cell is suspected.


## Scripts

### 1. Functional annotation tools: 

* Analysis:

bash eggnog + interpro

scRNA_FuAnnotations.Rmd

* Graphical outputs:



### 2. HMM profile search: 

* Analysis:

HMM_search.sh

hmm_fasta_convert_{lifestage}.sh

fasta_folders_{lifestage}.sh


* Graphical outputs:

2 bash scripts + 1 R: node_count.sh, hmm_graphics_2.sh, scRNA_HMM.Rmd


++scRNA_HMM.Rmd

![Graphical](HMM_heatmap_overview.png)



### 3. Blast identified gene reads on reference protist genes: 




### 4. Orthofinder: 




### 5. Phylogenetic reconstructions: 

#### Species Tree
Recovery of rRNA sequences in transcriptomes:
````
#!/bin/sh
#
#SBATCH --job-name rrna_recovery
#SBATCH --cpus-per-task=2
#SBATCH -o o.rrna
#SBATCH -e e.rrna
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# For every eukaryotic fasta file
for f in /shared/projects/swarmer_radiolaria/finalresult/rrna/*euk*.fasta;
do
   echo "looping 1 "${f##*/}""
   id=${f##*/}
   sed "s/)/)$id/g" ${f} | tr -d "\n" | sed 's/>/\n>/g' | grep "18S_rRNA" | sed 's/.fasta/\n/g' >> 18S_rRNA.fasta
   sed "s/)/)$id/g" ${f} | tr -d "\n" | sed 's/>/\n>/g' | grep "28S_rRNA" | sed 's/.fasta/\n/g' >> 28S_rRNA.fasta
   sed "s/)/)$id/g" ${f} | tr -d "\n" | sed 's/>/\n>/g' | grep "5_8S_rRNA" | sed 's/.fasta/\n/g' >> 5_8S_rRNA.fasta
   sed "s/)/)$id/g" ${f} | tr -d "\n" | sed 's/>/\n>/g' | grep "5S_rRNA" | sed 's/.fasta/\n/g' >> 5_8S_rRNA.fasta
done
##

````

Identify the dominant form of ribosomal transcript in the cell according to gene expression:


Maximum likelihood phylogenetic reconstruction using raxML-ng, evolutionary model GTR+G:






#### Gene Trees

Multiple Sequence Alignment (MSA) using FSA (Fast Statistical ALignment) based on pairwised estimations of homology.

````
# Quick alignment

time fsa seq.fasta > seq_aligned.fasta

````

Maximum Likelihood (ML) phylogenetic recostruction using raxML-ng, evolutionary model JTT+G for proteins.

````
module load raxml-ng/1.1.0

# Step 1 ~ check: check that the MSA is compatible with raxML 
raxml-ng --check --msa-format FASTA --msa seq_aligned.fasta --model JTT+G --prefix T1

# Information about duplicate sequences, nb of sites and proportion of gaps and invariant sites is printed

# Step 2 ~ parse: estimate the optimal parameters (memory, nb threads) for calculating the phylogeny with the given data
raxml-ng --parse --msa T1.raxml.phy --model JTT+G --prefix T2

# Step 3 ~ phylogeny: the default nb of starting trees is 20, 10 random + 10 parsimony
raxml-ng --msa T1.raxml.phy --model JTT+G --prefix T3 --seed $RANDOM --threads 6

# To gain in time the nb of starting trees can be set manually:
raxml-ng --msa T1_hapOGA.raxml.reduced.phy --model JTT+G --prefix T3_hapOGA --seed $RANDOM --threads 4 --workers 10 --tree "pars{2},rand{2}" 

# Step 4 ~ multiple best topologies in tree space? Ideally, one topology is the best.
raxml-ng --rfdist --tree T3.raxml.mlTrees --prefix T4_RF

# Step 5 ~ bootstrap (BS): test the robustness of the best ML tree by randomnly modifying the MSA
raxml-ng --bootstrap --msa T1.raxml.phy --model JTT+G --prefix T5 --seed 2 --threads 6 --bs-trees 100

# Step 6 ~ add BS values: add bootstrap support values on the best ML tree
raxml-ng --support --tree T3.raxml.bestTree --bs-trees T4.raxml.bootstrap --prefix T6

# One-step command: tree inference and bootstrapping, i.e. steps 3, 5 and 6
raxml-ng --all --msa pT1.raxml.phy --model JTT+G --prefix All --seed $RANDOM --threads 8 --extra thread-pin --bs-metric fbp --bs-trees 100

````







## Next steps

Building a phylogenetic tree of identified genes and validating radiolarian specific marker genes of the sexual cycle (SexCy markers). 
