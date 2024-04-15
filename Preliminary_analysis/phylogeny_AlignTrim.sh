#!/bin/bash
#
#SBATCH --job-name align
#SBATCH --cpus-per-task=6
#SBATCH -o o.align.%N.%j
#SBATCH -e e.align.%N.%j
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Load modules
module load mafft/7.515
module load trimal/1.4.1

# File
file="V4_sc_ref_0804_Acanth.fasta"

# Make sure file does not contain special characters
sed -i 's/:/_/g' ${file}
sed -i 's/(+)/_/g' ${file}
sed -i 's/(-)/_/g' ${file}
sed -i 's/;/\n/g' ${file}

# MSA: command for <200 sequences, ~lengths, closely related groups:
mafft --maxiterate 1000 --globalpair  ${file} > "aligned_"${file}

#mafft --auto  ${file} > "aligned_"${file}

# Filtration of MSA
trimal -in aligned_${file} -out "aligned_trimmed_"${file} -gt 0.3

##
