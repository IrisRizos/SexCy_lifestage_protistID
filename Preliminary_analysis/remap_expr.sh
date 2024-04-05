#!/bin/sh
#
#SBATCH --job-name genexp
#SBATCH --cpus-per-task=6
#SBATCH -o o.genexp2
#SBATCH -e e.genexp2
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# trinity/2.13.2
# perl/5.26.2

today=$(date +%F)

# For every vegetative file
for f in /shared/projects/swarmer_radiolaria/finalresult/rate_remapping/*.log;
do
   srun abundance_estimates_to_matrix.pl \
   --est_method salmon \
   --out_prefix Matrix_genexpr_${f##*/}_${today}_ \
   --name_sample_by_basedir \
   --gene_trans_map none \
   ${f}/quant.sf \
done

##
