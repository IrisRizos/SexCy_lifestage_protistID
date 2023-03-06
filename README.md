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
Peptidome data

````
#!/bin/sh
#
#SBATCH --job-name hmmsearch
#SBATCH --cpus-per-task=4
#SBATCH -o o.hmmS
#SBATCH -e e.hmmS
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

today=$(date +%F)

# Run by life stage
# ${f##*/} allows to remove f extension and keep filename only

for f in /shared/projects/rhizaria_ref/Sexual_cycle/adult/*/*;
do
    hmmsearch -A adult/hmm_gamete_${f##*/}_${today}.sto -o adult/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout adult/hmm_gamete_${f##*/}_${today}.tsv HMM_search_gamete_ref.hmm ${f} 
    hmmsearch -A adult/hmm_meiosis_${f##*/}_${today}.sto -o adult/hmm_meiosis_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout adult/hmm_meiosis_${f##*/}_${today}.tsv HMM_search_meiosis_ref.hmm ${f} 
done

for f in /shared/projects/rhizaria_ref/Sexual_cycle/swarmer/*/*;
do
    hmmsearch -A swarmer/hmm_gamete_${f##*/}_${today}.sto -o swarmer/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout swarmer/hmm_gamete_${f##*/}_${today}.tsv HMM_search_gamete_ref.hmm ${f} 
    hmmsearch -A swarmer/hmm_meiosis_${f##*/}_${today}.sto -o swarmer/hmm_meiosis_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout swarmer/hmm_meiosis_${f##*/}_${today}.tsv HMM_search_meiosis_ref.hmm ${f} 
done
##

````

Transcripts blasting with query domains were recovered in fasta files.
Headers contain the query id with which the node significantly blasted (eval < 0.001) and the transcriptome id of the alignment.

The following script allows to convert alignements in stockholm format to the fasta file described above.
For that the use of easel miniapps implemented in HMMER is necessary (http://cryptogenomicon.org/extracting-hmmer-results-to-sequence-files-easel-miniapplications.html).

````
#!/bin/sh
#
#SBATCH --job-name hmm_fasta
#SBATCH --cpus-per-task=2
#SBATCH -o o.hmm
#SBATCH -e e.hmm
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

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
   sed 's/  */ /g' ${f} | awk -F " " '/^N/ {print$1";"$4}' > node_${f##*/}.txt
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
      awk -v var1="$node" -v var2="$query" '/^>/ {print ">"var1"/"var2"/"$0} ; !/^>/ {print $0}' ${f##*/}.fasta | awk -F "/" '/^>/ {if ($1==$3) {print ">"$2"/"$3}} ; !/^>/ {print $0}' >> query_${f##*/}.fasta
   done
done

# Add transcriptome id in header of each sequence
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/query_*.txt.fasta;
do
   id_name=$(echo "${f##*/}")
   echo "$id_name"
   awk -v name="$id_name" '/^>/ {print$0"/"name} ; !/^>/ {print$0}' ${f} | sed 's/\/>/\//g' | sed 's/.txt.fasta//g' > final_${f##*/}
done
##
````

#### 1.3 Blast identified gene reads on reference protist genes: 
Transcriptome data


### 2. Comparative approach

#### 2.1 Creating clusters of ortholog genes:
Orthofinder

#### 2.2 Phylogenetic relationships of sexual genes:
Are the gene trees and species tree congruent ?


## Reference protist genes

Gamete related = 11
among which 10 gamete specific =

Meiosis related = 33
among which X meiosis specific =


## Life stages

The radiolarian life stages studied here are:

-Swarmer: hypothetical gamete stage 
The expression of gamete reference genes is investigated among 4 single-cell swarmer transcriptomes of 3 acantharian and 1 collodarian species.

-Meiosis: stage before swarmer release, morphologically identifiable by a change of color, size, shape and granulosity of the cell 

Two types of meiosis stages are supposed to apply to Radiolaria according to the modality of swarmer release:

--Vegetative swarming: the overall shape of the cell remains the same while swarmers emerge from the cytoplasm

Samples include 1 acantharian, 1 spumellarian and 1 foraminiferan species.

--Cyst swarming: the cell forms a dense and opaque round-shaped structure from which swarmer emerge either through a pore or the periphery of the cyst

Samples include 2 acantharian species among which one also undergone vegetative swarming (i.e. one of the acantharian swarmer samples).

Both the expression of meiosis and gamete reference genes is investigated as the presence of swarmers inside the cell is suspected.


## Scripts

### 1. Functional annotation tools: 
bash eggnog + interpro

scRNA_FuAnnotations.Rmd

### 2. HMM profile search: 
bash

scRNA_HMM.Rmd


### 3. Blast identified gene reads on reference protist genes: 


### 4. Orthofinder: 


### 5. Phylogenetic reconstructions: 


## Next steps

Building a phylogenetic tree of identified genes and validating radiolarian specific marker genes of the sexual cycle (SexCy markers). 
