# How to identify sexual cycle cues among uncultivable protists ?


From a genetic point of view, sexual processes seem to have arosen early in the evolution of eukaryotes and be widespread, even though observations of such mechanisms among protists are scarce (Speijer et al. 2015, Goodenough & Heitman 2014). The molecular basis of sexuality is linked to 2 cellular mechanisms: meiotic division (i.e. reduction of cell ploidy) and gamete fusion (i.e. restoration of cell ploidy to pre-meiotic stages) (Speijer et al. 2015, Goodenough & Heitman 2014).

For Rhizaria that are a tedious lineage to cultivate, genetic cues can help understand the reproductive mechanisms involved in their mysterious life cycle. Sexual reproduction has been observed among some cultivable rhizarian lineages (e.g. Phytomyxea and benthic Foraminifera) but remains enigmatic for Radiolaria. The existence of a sexual cycle has long been speculated, notably by Schewiakoff ~100 years ago. Since then, the lifespan, ploidy and role of each radiolarian life stage observed on the field remain to be resolved.

The present github includes the code for identifying reference protist genes specific to gamete and meiotic life stages based on single-cell transcriptomes of Radiolaria.

![Graphical](Fig1_A.png)

## Methods

### 1. Functional annotation tools: 
EggNog, Interproscan


### 2. HMM profile search: 
Peptidome data


### 3. Blast identified gene reads on reference protist genes: 
Transcriptome data


## Reference protist genes

Gamete related = 11
among which 10 gamete specific =

Meiosis related = 33
among which X meiosis specific =


## Life stages

The radiolarian life stages studied here are:

-Swarmer: hypothetical gamete stage 
The expression of gamete reference genes is investigated among 4 single-cell swarmer transcriptomes of 3 acantharian and 1 collodarian species.

-Meiosis: stage before swarmer release, morphologically identifiable by a change of color, size, shape and granulosity of the cell 

Two types of meiosis stages are supposed to apply to Radiolaria according to the modality of swarmer release:
--Vegetative swarming: the overall shape of the cell remains the same while swarmers emerge from the cytoplasm
Samples include 1 acantharian, 1 spumellarian and 1 foraminiferan species

--Cyst swarming: the cell forms a dense and opaque round-shaped structure from which swarmer emerge either through a pore or the periphery of the cyst
Samples include 2 acantharian species among which one also undergone vegetative swarming (i.e. one of the acantharian swarmer samples)

Both the expression of meiosis and gamete reference genes is investigated as the presence of swarmers inside the cell is suspected.


## Scripts

### 1. Functional annotation tools: 
bash eggnog + interpro

scRNA_FuAnnotations.Rmd

### 2. HMM profile search: 
bash

scRNA_HMM.Rmd


### 3. Blast identified gene reads on reference protist genes: 


## Next steps

Building a phylogenetic tree of identified genes and validating radiolarian specific marker genes of the sexual cycle (SexCy markers). 
