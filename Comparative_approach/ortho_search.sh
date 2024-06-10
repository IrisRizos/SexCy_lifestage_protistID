#!/bin/bash
#SBATCH --job-name orthof
#SBATCH --cpus-per-task=4
#SBATCH -o o.orthof_%N.%j
#SBATCH -e e.orthof_%N.%j
#SBATCH --mail-user=
#SBATCH --mail-type=BEGIN,FAIL,END

# Module
module load orthofinder/2.5.2

# Command
orthofinder -f /[path to folder with predicted proteomes]/
