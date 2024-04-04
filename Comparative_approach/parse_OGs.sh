#!/bin/bash
#SBATCH --job-name bash
#SBATCH --cpus-per-task=6
#SBATCH -o o.parse_OrthoF.%N.%j.2703
#SBATCH -e e.parse_OrthoF.%N.%j.2703
#SBATCH --mail-user=iris.rizos@sb-roscoff.fr
#SBATCH --mail-type=ALL

#~~# 1.Life stage specific gene counts #~~#
# Get list of swarmer specific OGs, common to all swarmers and gene counts
mkdir SW_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$8>0 && $9>0 && $10>0 && $2+$3+$4+$5+$6+$7==0 {print $0}' > SW_OG/SW_SW_OG_count.csv

# Get list of big swarmer specific OGs
mkdir SWb_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$10>0 && $2+$3+$4+$5+$6+$7+$8+$9==0 {print $0}' > SWb_OG/SWb_SWb_OG_count.csv

# Get list of cyst specific OGs, common to all cysts and gene counts
mkdir CY_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$2>0 && $3>0 && $4+$5+$6+$7+$8+$9+$10==0 {print $0}' > CY_OG/CY_CY_OG_count.csv

# Get list of vegetative specific OGs, common to all vegetative stages only and gene counts
mkdir VE_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$4>0 && $5>0 && $6>0 && $7>0 && $2+$3+$8+$9+$10==0 {print $0}' > VE_OG/VE_VE_OG_count.csv

# Get list of reproductive specific OGs, common to all reproductive stages and gene counts
mkdir Reprod_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$2>0 && $3>0 && $8>0 && $9>0 && $10>0 && $4+$5+$6+$7==0 {print $0}' > Reprod_OG/R_R_OG_count.csv

# Swarmer and vegetative OGs (all samples)
mkdir SW_VE_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$4>0 && $5>0 && $6>0 && $7>0 && $8>0 && $9>0 && $10>0 && $2+$3==0 {print $0}' > SW_VE_OG/SW_VE_OG_count.csv

# Big swarmer and vegetative OGs
mkdir SWb_VE_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$4>0 && $5>0 && $6>0 && $7>0 && $10>0 && $2+$3+$8+$9==0 {print $0}' > SWb_VE_OG/SWb_VE_OG_count.csv

# Cyst and vegetative OGs (all samples)
mkdir CY_VE_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$2>0 && $3>0 && $4>0 && $5>0 && $6>0 && $7>0 && $8+$9+$10==0 {print $0}' > CY_VE_OG/CY_VE_OG_count.csv

# Get list of OGs, common to all life stages
mkdir All_lifestages_OG/
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$2>0 && $3>0 && $4>0 && $5>0 && $6>0 && $7>0 && $8>0 && $9>0 && $10>0 {print $0}' > All_lifestages_OG/All_OG_count.csv


#~~# 2.Life stage specific OG ids #~~#
# Get list of swarmer specific OG ids, common to all swarmers and gene counts
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$8>0 && $9>0 && $10>0 && $2+$3+$4+$5+$6+$7==0 {print$1".fa"}' > SW_OG/SW_SW_OG_ids.csv

# Get list of big swarmer specific OG ids and gene counts
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$10>0 && $2+$3+$4+$5+$6+$7+$8+$9==0 {print$1".fa"}' > SWb_OG/SWb_SWb_OG_ids.csv

# Get list of cyst specific OG ids, common to all cysts and gene counts
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$2>0 && $3>0 && $4+$5+$6+$7+$8+$9+$10==0 {print$1".fa"}' > CY_OG/CY_CY_OG_ids.csv

# Get list of vegetative specific OG ids, common to all vegetative stages and gene counts
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$4>0 && $5>0 && $6>0 && $7>0 && $2+$3+$8+$9+$10==0 {print$1".fa"}' > VE_OG/VE_VE_OG_ids.csv

# Get list of cyst and swarmer specific OG ids
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$2>0 && $3>0 && $8>0 && $9>0 && $10>0 && $4+$5+$6+$7==0 {print $1".fa"}' > Reprod_OG/R_R_OG_ids.csv

# Get list of swarmer and vegetative specific OG ids
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$4>0 && $5>0 && $6>0 && $7>0 && $8>0 && $9>0 && $10>0 && $2+$3==0 {print $1".fa"}' > SW_VE_OG/SW_VE_OG_ids.csv

# Get list of big swarmer and vegetative specific OG ids
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$4>0 && $5>0 && $6>0 && $7>0 && $10>0 && $2+$3+$8+$9==0 {print $1".fa"}' > SWb_VE_OG/SWb_VE_OG_ids.csv

# Get list of OGs, common to all life stages
sed 's/\t/;/g' Orthogroups.GeneCount.tsv | awk -F";" '$2>0 && $3>0 && $4>0 && $5>0 && $6>0 && $7>0 && $8>0 && $9>0 && $10>0 {print $1".fa"}' > All_lifestages_OG/All_OG_ids.csv

#~~# 3.Move life stage specific OGs in separate folder #~~#
# Swarmer
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SW_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=SW_SW_OG_ids.csv Common_OG/
echo "swarmer OGs"
ls Common_OG/ | wc -l

# Big swarmer
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SWb_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=SWb_SWb_OG_ids.csv Common_OG/
echo "big swarmer OGs"
ls Common_OG/ | wc -l

# Cyst
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/CY_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=CY_CY_OG_ids.csv Common_OG/
echo "cyst OGs"
ls Common_OG/ | wc -l

# Vegetative
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/VE_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=VE_VE_OG_ids.csv Common_OG/
echo "vegetative OGs"
ls Common_OG/ | wc -l

# Reprod (SW+CY)
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/Reprod_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=R_R_OG_ids.csv Common_OG/
echo "Reprod OGs"
ls Common_OG/ | wc -l

# Swarmer + vegetative
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SW_VE_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=SW_VE_OG_ids.csv Common_OG/
echo "Swarmer + vegetative OGs"
ls Common_OG/ | wc -l

# Swarmer big + vegetative
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SWb_VE_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=SWb_VE_OG_ids.csv Common_OG/
echo "Swarmer big + vegetative OGs"
ls Common_OG/ | wc -l

# All
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/All_lifestages_OG/
srun rsync -a /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroup_Sequences/ --files-from=All_OG_ids.csv Common_OG/
echo "All life stages OGs"
ls Common_OG/ | wc -l


#~~# 4.Create table with list of nodes in each OG #~~#
## Swarmer
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SW_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> SW_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' SW_node_OG.csv
sed -i 's/.fa//g' SW_node_OG.csv
sed -i 's/.p[0-9]//g' SW_node_OG.csv
sed -i '1inode;OG' SW_node_OG.csv

## Big swarmer
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SWb_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> SWb_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' SWb_node_OG.csv
sed -i 's/.fa//g' SWb_node_OG.csv
sed -i 's/.p[0-9]//g' SWb_node_OG.csv
sed -i '1inode;OG' SWb_node_OG.csv

## Cyst
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/CY_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> CY_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' CY_node_OG.csv
sed -i 's/.fa//g' CY_node_OG.csv
sed -i 's/.p[0-9]//g' CY_node_OG.csv
sed -i '1inode;OG' CY_node_OG.csv

## Vegetative
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/VE_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> VE_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' VE_node_OG.csv
sed -i 's/.fa//g' VE_node_OG.csv
sed -i 's/.p[0-9]//g' VE_node_OG.csv
sed -i '1inode;OG' VE_node_OG.csv

## Reprod
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/Reprod_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> Reprod_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' Reprod_node_OG.csv
sed -i 's/.fa//g' Reprod_node_OG.csv
sed -i 's/.p[0-9]//g' Reprod_node_OG.csv
sed -i '1inode;OG' Reprod_node_OG.csv

## Swarmer + vegetative
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SW_VE_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> SW_VE_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' SW_VE_node_OG.csv
sed -i 's/.fa//g' SW_VE_node_OG.csv
sed -i 's/.p[0-9]//g' SW_VE_node_OG.csv
sed -i '1inode;OG' SW_VE_node_OG.csv

## Swarmer big + vegetative
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/SWb_VE_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> SWb_VE_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' SWb_VE_node_OG.csv
sed -i 's/.fa//g' SWb_VE_node_OG.csv
sed -i 's/.p[0-9]//g' SWb_VE_node_OG.csv
sed -i '1inode;OG' SWb_VE_node_OG.csv

# All
cd /shared/projects/swarmer_radiolaria/finalresult/ortholog/Acantharia/OrthoFinder/Results_Jan30/Orthogroups/All_lifestages_OG/
for f in Common_OG/*.fa;
do
  echo "OG file: "${f##*/}""
  OG=${f##*/}
  awk -v og="$OG" '/^>/ {print$0";"og}' ${f} >> All_node_OG.csv
done

# Modify file to match eggnog annotations
sed -i 's/>//g' All_node_OG.csv
sed -i 's/.fa//g' All_node_OG.csv
sed -i 's/.p[0-9]//g' All_node_OG.csv
sed -i '1inode;OG' All_node_OG.csv

##
