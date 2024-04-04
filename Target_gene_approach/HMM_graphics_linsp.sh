#!/bin/bash
#
#SBATCH --job-name bash
#SBATCH --cpus-per-task=4
#SBATCH -o o.hmmsearch.%N.%j.0902
#SBATCH -e e.hmmsearch.%N.%j.0902
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=ALL

# Gather additional data of HMM output:
## v1: HMMER stats and pr id
## v2: add transcriptome version
## v3: add dample id
## v4: set life stage
# Add query id to each target sequence significantly aligned (to its query) and alignement score
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/Gamete_pr/GEX1_KAR5_IPR040346/run/*.tsv;
do
   ext=${f##*/hmm_gamete_}
   filename=${ext%%_2024*}
   echo "${ext} / ${filename}"
   sed 's/  */ /g' ${f} | awk -v name="$filename" -F " " '/^N/ || /^T/ {print$1";"$4";"$7";"$8";"$12";"$13";"$14";"name";swarmer;"($17-$16+1)/$6";"$22";GEX1-KAR5"}' | sed 's/(+),score=//g' | sed 's/(-),score=//g' | sed 's/.fasta_aligned//g' | uniq >> node_query_score.csv
done

awk -F";" '$8 ~/_hard_/ || $8 ~/_H_/ || $8 ~/_hf/ {print$0";H"}' node_query_score.csv > node_query_score_2.csv
awk -F";" '$8 ~/TransDecoder_on_hf44/ {print$0";A1_Vi_SW"} ; $8 ~/TransDecoder_on_hf45/ {print$0";A2_Vi_SW"} ; $8 ~/TransDecoder_on_hf46/ {print$0";A3_Vi_SW"} ; $8 ~/M357/ {print$0";C1_Mo_SW"} ; $8 ~/M380/ {print$0";F2_Mo_ME"} ; $8 ~/SP22/ {print$0";A5_Vi_ME"} ; $8 ~/EiSpum/ {print$0";S1_Ei_MESW"} ; \
 $8 ~/M345/ {print$0";F1_Mo_MESW"} ; $8 ~/E561/ {print$0";A4_Vi_CY"} ; $8 ~/E587/ {print$0";A2_Vi_CY"} ; $8 ~/GC128823/ {print$0";GC128823"} ; $8 ~/GC128840/ {print$0";GC128840"} ; $8 ~/GC128847/ {print$0";GC128847"} ; \
 $8 ~/actinelius/ {print$0";Actinelius_pr"} ; $8 ~/GC128858/ {print$0";GC128858"}' node_query_score_2.csv > node_query_score_3.csv
awk -F";" '{OFS = FS} $14 ~/_ME/ {$9="meiosis"} ; $14 ~/_CY/ {$9="cyst"} ; $14 !~/_ME/ && $14 !~/_SW/ && $14 !~/_CY/ {$9="vegetative"} ; {print$0}' node_query_score_3.csv > node_query_score_4.csv

# Add nb of nodes in each transcriptome
cd /shared/projects/swarmer_radiolaria/finalresult/HMM/run/graphics/
for i in $(cat node_count_MESW.csv);
do
  echo "$i"
  count=$(echo "$i" | cut -d';' -f1)
  target=$(echo "$i" | cut -d';' -f2)
  echo "$target;$count"
  cd /shared/projects/swarmer_radiolaria/finalresult/HMM/Gamete_pr/run/graphics/
  awk -v targ="$target" -v nb="$count" -F";" '$8==targ {print$0";"nb}' node_query_score_4.csv >> node_count_query_score_hits.csv
done
##
