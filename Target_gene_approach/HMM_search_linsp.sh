#!/bin/bash
#SBATCH --job-name HMMER
#SBATCH --cpus-per-task=4
#SBATCH -o o.hmmsearch.%N.%j.1812
#SBATCH -e e.hmmsearch.%N.%j.1812
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=ALL

# Load module
module load hmmer/3.2.1

# Day variable
today=$(date +%F)

# Search for hmm profile by life stage
# -A MSA of all hits
# -o file instead of stdout

for f in /shared/projects/rhizaria_ref/finalresult/Sexual_cycle/meiosis_swarmer/*/*;
do
   hmmsearch -A run/hmm_gamete_${f##*/}_${today}.sto -o run/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout run/hmm_gamete_${f##*/}_${today}.tsv GEX1_IPR040346_multilin.hmm ${f}
done

for f in /shared/projects/rhizaria_ref/finalresult/Sexual_cycle/cyst/*;
do
   hmmsearch -A run/hmm_gamete_${f##*/}_${today}.sto -o run/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout run/hmm_gamete_${f##*/}_${today}.tsv GEX1_IPR040346_multilin.hmm ${f}
done

for f in /shared/projects/rhizaria_ref/finalresult/Sexual_cycle/adult/Acantharia/*.pep;
do
   hmmsearch -A run/hmm_gamete_${f##*/}_${today}.sto -o run/hmm_gamete_${f##*/}_${today}.txt --incdomE 0.001 --domE 0.001 --domtblout run/hmm_gamete_${f##*/}_${today}.tsv GEX1_IPR040346_multilin.hmm ${f}
done

##
