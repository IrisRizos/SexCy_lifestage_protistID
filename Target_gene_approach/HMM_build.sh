#!/bin/bash
#SBATCH --job-name HMMER
#SBATCH --cpus-per-task=6
#SBATCH -o o.hmmbuild.%N.%j.0902
#SBATCH -e e.hmmbuild.%N.%j.0902
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=ALL

# Load modules
module load mafft/
module load hmmer/

for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/Gamete_pr/GEX1_KAR5_IPR040346/*.fasta;
do
  # Align sequences
   mafft --auto --thread 6 ${f} > ${f##*/}_aligned.fasta
   # Convert in stockholm format
   esl-reformat stockholm ${f##*/}_aligned.fasta > ${f##*/}_aligned.sto
   # Build HMM profile
   hmmbuild ${f##*/}.hmm ${f##*/}_aligned.sto
done
