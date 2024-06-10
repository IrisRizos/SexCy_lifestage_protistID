#!/bin/sh
#
#SBATCH --job-name bash
#SBATCH --cpus-per-task=4
#SBATCH -o o.barnap.%N.%j
#SBATCH -e e.barnap.%N.%j
#SBATCH --mail-user=
#SBATCH --mail-type=ALL

module load barrnap/0.9

barrnap --kingdom 'euk' --threads '4' --outseq '[sample]_euk_rRNA.fasta' [file].cds

##
