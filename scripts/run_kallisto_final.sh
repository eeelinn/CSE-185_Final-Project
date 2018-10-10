#!/bin/bash

# Set variables used in each kallisto run
PUBLIC=~/cse185-final-project-eeelinn/analysis_reads
KINDEX=${PUBLIC}/s_mediterranea_unigene

# Do separate kallisto runs per dataset
for prefix in ERR032066 ERR032068 ERR032071
do
	kallisto quant -t 3 -b 100 -o $prefix'_REP1' -i $KINDEX ${PUBLIC}/$prefix'_1_REP1.fq' ${PUBLIC}/$prefix'_2_REP1.fq'

	kallisto quant -t 3 -b 100 -o $prefix'_REP2' -i $KINDEX ${PUBLIC}/$prefix'_1_REP2.fq' ${PUBLIC}/$prefix'_2_REP2.fq'

done
