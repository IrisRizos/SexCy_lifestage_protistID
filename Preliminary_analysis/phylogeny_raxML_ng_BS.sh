#!/bin/bash
#SBATCH --job-name raxML
#SBATCH --cpus-per-task=12
#SBATCH -o o.raxML.%N.%j
#SBATCH -e e.raxML.%N.%j
#SBATCH --mail-user=
#SBATCH --mail-type=ALL

# Load program
module load raxml-ng/1.1.0

today=$(date +%F)
MSA="[trimmed alignment].fasta"

# Tree inference coupled to bootstrapping
raxml-ng --all --msa ${MSA} --model GTR+G --prefix "All_"${today} --seed $RANDOM --threads $SLURM_CPUS_ON_NODE --force perf_threads --extra thread-pin --bs-metric fbp --bs-trees 100

##
