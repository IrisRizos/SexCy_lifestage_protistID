#!/bin/sh
#
#SBATCH --job-name hmmsearch
#SBATCH --cpus-per-task=4
#SBATCH -o o.hmmS
#SBATCH -e e.hmmS
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Search for conserved domains of gamete specific and meiosis specific protist genes among radiolarian single-cell life stages

module load hmmer/3.2.1

# SPB-44
hmmsearch HMM_search_gamete_ref.hmm /shared/projects/swarmer_radiolaria/finalresult/peptidomes/TransDecoder_on_hf44_Results_PEP.fasta > hmm_gamete_44_071022.out
hmmsearch HMM_search_meiosis_ref.hmm /shared/projects/swarmer_radiolaria/finalresult/peptidomes/TransDecoder_on_hf44_Results_PEP.fasta > hmm_meiosis_44_071022.out

# SPC-45
hmmsearch HMM_search_gamete_ref.hmm /shared/projects/swarmer_radiolaria/finalresult/peptidomes/TransDecoder_on_hf45_Results_PEP.fasta > hmm_gamete_45_071022.out
hmmsearch HMM_search_meiosis_ref.hmm /shared/projects/swarmer_radiolaria/finalresult/peptidomes/TransDecoder_on_hf45_Results_PEP.fasta > hmm_meiosis_45_071022.out

# C3-46
hmmsearch HMM_search_gamete_ref.hmm /shared/projects/swarmer_radiolaria/finalresult/peptidomes/TransDecoder_on_hf46_Results_PEP.fasta > hmm_gamete_46_071022.out
hmmsearch HMM_search_meiosis_ref.hmm /shared/projects/swarmer_radiolaria/finalresult/peptidomes/TransDecoder_on_hf46_Results_PEP.fasta > hmm_meiosis_46_071022.out
