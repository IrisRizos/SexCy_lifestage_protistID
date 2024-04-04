#!/bin/bash
#
#SBATCH --job-name hmmsearch
#SBATCH --cpus-per-task=4
#SBATCH -o o.hmmS.%N.%j.1001
#SBATCH -e e.hmmS.%N.%j.1001
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Load module
module load hmmer/

# Date of analysis
today=$(date +%F)

# Reference HMM profiles files
HMM_G="HMM_search_gamete_ref.hmm"
HMM_M="HMM_search_meiosis_ref.hmm"

# Run by life stage
# ${f##*/} allows to remove f extension and keep filename only

for f in /shared/projects/rhizaria_ref/finalresult/Sexual_cycle/adult/*/*.pep;
do
    hmmsearch -A adult/hmm_gamete_${f##*/}_${today}.sto -o adult/hmm_gamete_${f##*/}_${today}.txt --cut_ga --domtblout adult/hmm_gamete_${f##*/}_${today}.tsv $HMM_G ${f}
    hmmsearch -A adult/hmm_meiosis_${f##*/}_${today}.sto -o adult/hmm_meiosis_${f##*/}_${today}.txt --cut_ga --domtblout adult/hmm_meiosis_${f##*/}_${today}.tsv $HMM_M ${f}
done

for f in /shared/projects/rhizaria_ref/finalresult/Sexual_cycle/meiosis_swarmer/*/*;
do
    hmmsearch -A swarmer/hmm_gamete_${f##*/}_${today}.sto -o swarmer/hmm_gamete_${f##*/}_${today}.txt --cut_ga --domtblout swarmer/hmm_gamete_${f##*/}_${today}.tsv $HMM_G >
    hmmsearch -A swarmer/hmm_meiosis_${f##*/}_${today}.sto -o swarmer/hmm_meiosis_${f##*/}_${today}.txt --cut_ga --domtblout swarmer/hmm_meiosis_${f##*/}_${today}.tsv $HMM>
done

for f in /shared/projects/rhizaria_ref/finalresult/Sexual_cycle/cyst/*;
do
    hmmsearch -A cyst/hmm_gamete_${f##*/}_${today}.sto -o cyst/hmm_gamete_${f##*/}_${today}.txt --cut_ga --domtblout cyst/hmm_gamete_${f##*/}_${today}.tsv $HMM_G ${f}
    hmmsearch -A cyst/hmm_meiosis_${f##*/}_${today}.sto -o cyst/hmm_meiosis_${f##*/}_${today}.txt --cut_ga --domtblout cyst/hmm_meiosis_${f##*/}_${today}.tsv $HMM_M ${f}
done

##
