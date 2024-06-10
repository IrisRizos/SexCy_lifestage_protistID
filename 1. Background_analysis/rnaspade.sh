#!/bin/bash
#SBATCH --cpus-per-task 10
#SBATCH --mem 100GB
#SBATCH -o log.%N.%j.out
#SBATCH -e log.%N.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH -p long

module load spades/3.15.5

files_dir="/[path to read directory]/"
R1=${files_dir}"R1.fastq.gz"
R2=${files_dir}"R2.fastq.gz"
result_dir="/[path to result directory]/"

mkdir -p ${result_dir}

# Run Spades
spades.py --rna -1 ${R1} -2 ${R2} -t 10 -m 100 -o ${result_dir}

##
