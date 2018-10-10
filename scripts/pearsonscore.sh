#!/bin/bash

# Set variables
PUBLIC=~/cse185-final-project-eeelinn/analysis_reads

# Run Pearson's score per dataset
for x in ERR032066_REP1 ERR032066_REP2 ERR032068_REP1 ERR032068_REP2 ERR032071_REP1 ERR032071_REP2
do  
	
	for j in ERR032066_REP1 ERR032066_REP2 ERR032068_REP1 ERR032068_REP2 ERR032071_REP1 ERR032071_REP2
	do 
		echo "$x $j"
	
		paste ${PUBLIC}/$x/abundance.tsv ${PUBLIC}/$j/abundance.tsv | cut -f 5,10 | grep -v tpm | awk '(!($1==0 && $2==0))' | datamash ppearson 1:2 
	
	done
 
done
