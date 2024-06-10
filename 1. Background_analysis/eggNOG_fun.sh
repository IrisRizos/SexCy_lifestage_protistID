#!/bin/bash
#
#SBATCH --job-name eggnog
#SBATCH --cpus-per-task=12
#SBATCH --mem 50G
#SBATCH -o o.egg.%N.%j
#SBATCH -e e.egg.%N.%j
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=ALL

module load eggnog-mapper/2.1.11

today=$(date +%F)

for f in [folder with predicted protein files]/*.pep;
do
  echo "${f##*/}"
emapper.py -i ${f} --itype proteins -m diamond --dmnd_algo auto -o ${f##*/}_${today} --evalue 0.001 --dbmem --cpu 12 --data_dir /shared/bank/eggnog-mapper/current/ --override
done

##
