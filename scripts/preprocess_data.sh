#!/bin/bash

#variables!
PUBLIC=~/cse185-final-project-eeelinn/original_files
OUTPUT=~/cse185-final-project-eeelinn/analysis_reads

mkdir ${OUTPUT}/fastqc

for x in ERR032066_1 ERR032066_2 ERR032068_1 ERR032068_2 ERR032071_1 ERR032071_2 
	do

	~/seqtk/seqtk sample -s100 ${PUBLIC}/$x.fastq.gz 1000000 > ${OUTPUT}/$x'_REP1'.fq
	~/seqtk/seqtk sample -s200 ${PUBLIC}/$x.fastq.gz 1000000 > ${OUTPUT}/$x'_REP2'.fq

	fastqc -o ${OUTPUT}/fastqc ${OUTPUT}/$x'_REP1'.fq
	fastqc -o ${OUTPUT}/fastqc ${OUTPUT}/$x'_REP2'.fq

	done

