#!/bin/bash
#
#SBATCH --job-name hmm_fasta
#SBATCH --cpus-per-task=2
#SBATCH -o o.hmm_convert
#SBATCH -e e.hmm_convert
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=BEGIN,FAIL,END

# Module
module load hmmer/3.2.1

# For every stockholm generated file of significant alignmnets: get target sequences in fasta
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.sto;
do
   esl-reformat -o fasta_files/node_${f##*/}.fasta fasta ${f}
done

# Change file extensions
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/*.sto.fasta;
do
   cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/
   mv "$f" "$(basename "$f" .sto.fasta).txt.fasta"
done

# Add query id to each target sequence significantly aligned (to its query)
cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv;
do
# Parse tsv to get node and query id
   sed 's/  */ /g' ${f} | awk -F " " '/^N/ {print$1";"$4}' | uniq > node_${f##*/}.txt
done

# Change file extensions
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/*.tsv.txt;
do
   mv "$f" "$(basename "$f" .tsv.txt).txt"
done

# Print query in front of corresponding node id of fasta file
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/node_*.txt;
do
   echo "looping 1 "${f##*/}""
   for i in $(cat ${f});
   do
      echo "im in the loop 2"
      node=$(echo $i | cut -d';' -f1)
      echo "$node"
      query=$(echo $i | cut -d';' -f2)
      echo "$query"
      cd /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/
      awk -v var1="$node" -v var2="$query" -F "/" '/^>/ {print $1"/"var1"/"var2"/"} ; !/^>/ {print $0}' ${f##*/}.fasta | tr -d "\n" | sed 's/>/\n/g' | awk -F "/" '{if ($1==$2) {print ">"$3"/"$2"\n"$4}}' >> query_${f##*/}.fasta
   done
done

# Add individual id in header of each sequence
for f in /shared/projects/swarmer_radiolaria/finalresult/HMM/swarmer/fasta_files/query_*.txt.fasta;
do
   id_name=$(echo "${f##*/}")
   echo "$id_name"
   sed 's/>\///g' ${f} | sed '/^$/d' | awk -v name="$id_name" '/^>/ {print$0"/"name} ; !/^>/ {print$0}' | sed 's/\/>/\//g' | sed 's/.txt.fasta//g' > final_${f##*/}
done
##
