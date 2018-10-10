#!/bin/bash

# Set variables
PUBLIC=~/cse185-final-project-eeelinn/analysis_reads

for x in ERR032066 ERR032068 ERR032071 
	do
	tophat -r 36 -o tophat_$x s_mediterranea ${PUBLIC}/$x'_1_REP1'.fq,${PUBLIC}/$x'_1_REP2'.fq ${PUBLIC}/$x'_2_REP1'.fq,${PUBLIC}/$x'_2_REP2'.fq
	done
