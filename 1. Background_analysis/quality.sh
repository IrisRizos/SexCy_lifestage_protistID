#!/bin/bash
#SBATCH --cpus-per-task 8
#SBATCH --mem 20GB
#SBATCH -o log.%N.%j.out
#SBATCH -e log.%N.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH -p fast

# Load modules
module load fastp/0.23.1 prinseq/0.20.4

# Set sample id
sample="[sample id]"

files_dir="/[path to raw read directory]/"
result_dir="/[path to desired clean read directory]/"
tmp_dir="/[path to directory for storing temporary files]/"
mkdir -p ${result_dir}
mkdir -p ${tmp_dir}

R1=${files_dir}${sample}"_R1.fastq.gz"
R2=${files_dir}${sample}"_R2.fastq.gz"

srun fastp -w 8 -i ${R1} -o ${result_dir}${sample}_R1.fastq.gz \
        -I ${R2} -O ${result_dir}${sample}_R2.fastq.gz \
        -x -g

# Output of fastp :
R1=${result_dir}${sample}"_R1.fastq.gz"
R2=${result_dir}${sample}"_R2.fastq.gz"

# unzip reads
new_R1=${tmp_dir}"_DELETE_"${sample}"_input_forward.fq"
new_R2=${tmp_dir}"_DELETE_"${sample}"_input_reverse.fq"

if [ ! -f ${new_R1} ]
then
        gunzip -c ${R1} > ${new_R1}
fi

if [ ! -f ${new_R2} ]
then
        gunzip -c ${R2} > ${new_R2}
fi

srun prinseq-lite.pl \
        -trim_qual_right 20 -min_qual_mean 25 -min_len 50 \
        -fastq ${new_R1} -fastq2 ${new_R2} \
        -custom_params "T 50;A 50" -ns_max_n 2 \
        -out_good ${result_dir}${sample}"_prinseq.fastq" -out_bad null

gzip ${result_dir}${sample}"_prinseq.fastq.gz_1.fastq"
gzip ${result_dir}${sample}"_prinseq.fastq.gz_2.fastq"

#srun fastqc ${result_dir}${sample}"_prinseq.fastq.gz_1.fastq.gz -t 6 -o ${tmp_dir}
#srun fastqc ${result_dir}${sample}"_prinseq.fastq.gz_1.fastq.gz -t 6 -o ${tmp_dir}

##
