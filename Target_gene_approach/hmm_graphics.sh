#!/bin/bash
#
#SBATCH --job-name bash
#SBATCH --cpus-per-task=2
#SBATCH -o o.bash2
#SBATCH -e e.bash2
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Gather additional data of HMM output:
# Add query id to each target sequence significantly aligned (to its query) and alignement score
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv;
do
   id_name=$(echo "${f##*/}")
   echo "$id_name"
   refpr=$(echo $id_name | cut -d'_' -f2)
   echo "$refpr"
   sed 's/  */ /g' ${f} | awk -v name="$id_name" -v ref="$refpr" -F " " '/^N/ {print$1";"$4";"$7";"$8";"$22";"$13";"$14";"name";swarmer;"($17-$16+1)/$6";"ref}' | sed 's/(+),score=//g' | sed 's/(-),score=//g' | uniq >> node_query_score.csv
done

awk -F";" '$8 ~/soft/ || $8 ~/S/ {print$0";S"} ; $8 !~/soft/ && $8 !~/S/ && $8 !~/hf/ && $8 !~/H/ && $8 !~/hard/ {print$0";T"} ; $8 ~/hard/ || $8 ~/H/ || $8 ~/hf/ {print$0";H"}' node_query_score.csv > node_query_score_2.csv
awk -F";" '$8 ~/hf44/ {print$0";A1_Vi_SW"} ; $8 ~/hf45/ {print$0";A2_Vi_SW"} ; $8 ~/hf46/ {print$0";A3_Vi_SW"} ; $8 ~/E561/ {print$0";A4_Vi_CY"} ; $8 ~/E587/ {print$0";A2_Vi_CY"} ; $8 ~/M345/ {print$0";F1_Mo_MESW"}  ; $8 ~/M357/ {print$0";C1_Mo_SW"} ; $8 ~/M380/ {print$0";F2_Mo_ME"} ; $8 ~/SP22/ {print$0";A5_Vi_ME"} ; $8 ~/EiSpum/ {print$0";S1_Ei_MESW"}' node_query_score_2.csv > node_query_score_3.csv
awk -F";" '{OFS = FS} $13 ~/ME/ {$9="meiosis"} ; {print$0}' node_query_score_3.csv > node_query_score_4.csv

   # Count number of hits per reference, meiosis
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv;
do
cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/
echo "looping 1 "${f##*/}""
   for i in $(cat meiosis_query_ids.txt);
    do
      echo "im in the loop 2, $i"
      hits=$(echo | grep -c "$i" ${f})
      echo "$i;${f##*/};$hits" >> ../graphics/meiosis_query_counts.csv
   done
      # Count number of hits per reference, gamete
   echo "looping 1 "${f##*/}""
   for i in $(cat gamete_query_ids.txt);
    do
      echo "im in the loop 2, $i"
      hits=$(echo | grep -c "$i" ${f})
      echo "$i;${f##*/};$hits" >> ../graphics/gamete_query_counts.csv
   done
done

cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/graphics/
grep -F -v ";0" meiosis_query_counts.csv > meiosis_query_counts2.csv && mv meiosis_query_counts2.csv meiosis_query_counts.csv
grep -F -v ";0" gamete_query_counts.csv > gamete_query_counts2.csv && mv gamete_query_counts2.csv gamete_query_counts.csv

for i in $(cat gamete_query_counts.csv);
do
  echo "$i"
  target=$(echo "$i" | cut -d';' -f2)
  hits=$(echo "$i" | cut -d';' -f3)
  pr=$(echo "$i" | cut -d';' -f1)
  echo "$target;$hits;$pr"
  awk -v tar="$target" -v hit="$hits" -v prot="$pr" -F";" '$8==tar && $2==prot {print$0";"hit}' node_query_score_4.csv >> node_query_score_hits.csv
done

for i in $(cat meiosis_query_counts.csv);
do
  echo "$i"
  target=$(echo "$i" | cut -d';' -f2)
  hits=$(echo "$i" | cut -d';' -f3)
  pr=$(echo "$i" | cut -d';' -f1)
  echo "$target;$hits;$pr"
  awk -v tar="$target" -v hit="$hits" -v prot="$pr" -F";" '$8==tar && $2==prot {print$0";"hit}' node_query_score_4.csv >> node_query_score_hits.csv
done

# Add nb of nodes in each transcriptome
for i in $(cat node_count_MESW.csv);
do
  echo "$i"
  count=$(echo "$i" | cut -d';' -f1)
  target=$(echo "$i" | cut -d';' -f2)
  echo "$target;$count"
  awk -v targ="$target" -v nb="$count" -F";" '$8~targ {print$0";"nb}' node_query_score_hits.csv >> node_count_query_score_hits.csv
done
##
