#!/bin/bash
#SBATCH -p fast
#SBATCH --mem-per-cpu=8GB
#SBATCH --cpus-per-task 8
#SBATCH --job-name=salmon_rate_remapping
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH -o log/rate_remapping_ADNU-71-1_hard.out
#SBATCH -e log/rate_remapping_ADNU-71-1_hard.err

module load trinity/2.13.2

WORKING_PATH="/shared/projects/swarmer_radiolaria/"
sample="ADNU-71-1"
R1="${WORKING_PATH}input/www.fasteris.com/private/clean/ADNU-71-1_prinseq.fastq_1.fastq.gz"
R2="${WORKING_PATH}input/www.fasteris.com/private/clean/ADNU-71-1_prinseq.fastq_2.fastq.gz"

## /!\ Careful about the symbolic link before running the script

srun align_and_estimate_abundance.pl \
        --transcripts ${WORKING_PATH}finalresult/rate_remapping/${sample}_hard_filtered_transcripts.fasta \
        --seqType fq \
        --left ${R1} \
        --right ${R2} \
        --est_method salmon \
        --trinity_mode \
        --prep_reference --thread_count 8 \
        --output_dir ${WORKING_PATH}tmp/rate_remapping/salmon_align_and_estimate_abundance_${sample}_hard.log
##
