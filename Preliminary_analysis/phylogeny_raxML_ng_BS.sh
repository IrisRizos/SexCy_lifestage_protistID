#!/bin/bash
#SBATCH --job-name raxML
#SBATCH --cpus-per-task=12
#SBATCH -o o.raxML.%N.%j.0804
#SBATCH -e e.raxML.%N.%j.0804
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=ALL

# Load program
module load raxml-ng/1.1.0

today=$(date +%F)
MSA="aligned_trimmed_V4_sc_ref_0804_Acanth.fasta"

# Tree inference
#raxml-ng --msa T1_autotrimG.raxml.reduced.phy --model JTT+G --prefix T3_hapOGA_100_autotrimG --seed $RANDOM --threads $SLURM_CPUS_ON_NODE --force perf_threads --extra thread-pin  --tree pars{2},rand{2}

# Tree inference coupled to bootstrapping
raxml-ng --all --msa ${MSA} --model GTR+G --prefix "All_"${today} --seed $RANDOM --threads $SLURM_CPUS_ON_NODE --force perf_threads --extra thread-pin --bs-metric fbp --bs-trees 100
