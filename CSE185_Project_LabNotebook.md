# Lab notebook for CSE185 Final Project

#### Erikka Linn

Lightning Talk: June 4, #16

## Preliminary Research

Research Question: Why can't humans regenerate nuerons very well? (fix this up a lil)
Regeneration => RNA-seq (like week 4) b/w animals that can regenerate and those that cannot (humans vs other)

Datasets:
  * planarian flatworms: head regeneration dataset: https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-607/
  * mouse brain development: https://www.nature.com/articles/srep07750#abstract
  * planarian RNai dataset: https://www.ncbi.nlm.nih.gov/sra/SRX4001641[accn]
  
  
Paper: 
 
 (egr-4 is important w/ brains)
 http://dev.biologists.org/content/141/9/1835.figures-only
 
 (dataset, original study)
 
 https://genomebiology.biomedcentral.com/articles/10.1186/gb-2011-12-8-r76
  
  Date needed in a dataset:
  * Brain RNA fastq from planarian
  * 2 samples of Body RNA fastq from planarian
  * Reference trascnriptome for planarian
  * Potentially find relevant ChIP-seq data

Ask about this as a potential project

look for an enhancer region of a specified gene to compare

## Drafting Ideas for Proposal

**Research Question** What genes are expressed/necessary during brain regeneration in *Schmidtea mediterranea* and how might they relate to humans? aka Why can *Schmidtea mediterranea* regenerate (their brains)?

[Dataset to Use]:(https://genomebiology.biomedcentral.com/articles/10.1186/gb-2011-12-8-r76)

DGE => genes expressed

cross check with egr-4 region in both this species as well as with others (some that regenerate and some that do not, maybe humans!)

Potential problems: aligning RNA w/ STAR or TopHat may take a long time :(, will need to find RNA sequencing data from multiple species with EGR-4 

## 5.29.18
downloaded Libraries 1, 3, and 6 from the dataset linked above

* Library 1: ERR032066_1.fastq,gz and ERR032066_2.fastq.gz
* Library 3: ERR032068_1.fastq.gz and ERR032068_2.fastq.gz
* Library 6: ERR032071_1.fastq.gz and ERR032071_2.fastq.gz

downloaded `seqtk` from github via:

	git clone https://github.com/lh3/seqtk.git
	cd seqtk 
	make

Find Size of original libraries:
	
	for x in ERR032066_1.fastq.gz ERR032066_2.fastq.gz ERR032068_1.fastq.gz ERR032068_2.fastq.gz ERR032071_1.fastq.gz ERR032071_2.fastq.gz 
	>do
	>zcat $x | echo $((`wc -l`/4))
	>done

gives:

|File|# of Reads|
|:-:|:-:|
|ERR032066_1|24250265|
|ERR032066_2|24250265|
|ERR032068_1|20600012|
|ERR032068_2|20600012|
|ERR032071_1|23720712|
|ERR032071_2|23720712|

**Process Libraries**

* downsample each library with seqtk to 2000000 reads (to around 10% of original)
* check quality with fastqc

loop:

	for x in ERR032066_1 ERR032066_2 ERR032068_1 ERR032068_2 ERR032071_1 ERR032071_2 
	>do
	>~/seqtk/seqtk sample -s100 $x.fastq.gz 2000000 > out_$x.fq
	>fastqc -o . out_$x.fq
	>done

all files are now around 250 MB (total 1.5 GB)

downloaded TopHat and Bowtie2

## 5.31.18

Downloaded reference genome: https://www.ncbi.nlm.nih.gov/nuccore/KF581192.1 
	
	efetch -db nucleotide -id KF581192.1 -format fasta > KF581192.1.fasta

moved to direfctory with reference genome and issued command:

	bowtie2-build KF581192.1.fasta s_mediterranea_BCN-10

to build own custom index for alignment

was unable to do too much, ran into errors working with tophat:

"Checking for Bowtie index files (genome)..\
Error: Could not find Bowtie 2 index files (test_ref.*.bt2l)"

## 6.3.18 (work over the weekend)
found this: https://github.com/infphilo/tophat/issues/43

downloaded bowtie2 version 2.2.9, tutorial for tophat now works

ran analysis but mapping was 0/2000 which is not good --> may just not use Tophat

## 6.5.18
got gtf file from: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3001875/#s3

renamed to `SmABi.fa`

made kallisto index: `kallisto index -i s_mediterranea-BCN10_kallisto SmABI.fa `

ran the kallisto script

kallisto output:

	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 42,590
	[index] number of k-mers: 19,007,004
	[index] number of equivalence classes: 64,422
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032066_1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032066_2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 2,000,000 reads, 992,063 reads pseudoaligned
	[quant] estimated average fragment length: 76.7082
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 708 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 42,590
	[index] number of k-mers: 19,007,004
	[index] number of equivalence classes: 64,422
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032066_1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032066_2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 2,000,000 reads, 992,063 reads pseudoaligned
	[quant] estimated average fragment length: 76.7082
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 708 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 42,590
	[index] number of k-mers: 19,007,004
	[index] number of equivalence classes: 64,422
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032068_1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032068_2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 2,000,000 reads, 1,020,207 reads pseudoaligned
	[quant] estimated average fragment length: 87.1532
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 677 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 42,590
	[index] number of k-mers: 19,007,004
	[index] number of equivalence classes: 64,422
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032068_1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032068_2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 2,000,000 reads, 1,020,207 reads pseudoaligned
	[quant] estimated average fragment length: 87.1532
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 677 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 42,590
	[index] number of k-mers: 19,007,004
	[index] number of equivalence classes: 64,422
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032071_1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032071_2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 2,000,000 reads, 1,027,554 reads pseudoaligned
	[quant] estimated average fragment length: 65.4392
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 976 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 42,590
	[index] number of k-mers: 19,007,004
	[index] number of equivalence classes: 64,422
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032071_1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-project-eeelinn/analysis_reads/out_ERR032071_2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 2,000,000 reads, 1,027,554 reads pseudoaligned
	[quant] estimated average fragment length: 65.4392
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 976 rounds
	[bstrp] number of EM bootstraps complete: 100

ran script to calculate pearson's score (datamash):

||out_ERR032066|out_ERR032068|out_ERR032071|
|:-:|:-:|:-:|:-:|
|out_ERR032066|1|0.9617030542768|0.90647730341186|
|out_ERR032068|0.9617030542768|1|0.86085023634467|
|out_ERR032071|0.90647730341186|0.86085023634467|1|

_66 and _68 are most similar, but also _68 is less similar to _71 than _66 is to _71, could the tissue DNA sequencing change over time?

maybe do a http://www.geneontology.org/page/go-enrichment-analysis (GO) analysis instead of tophat

## 6.6.18
Lab report **DUE SUNDAY (6/10) @ 11:59 PM**

trying tophat again: indexed w/ the SmABI.fa file instead this time

	for x in out_ERR032066 out_ERR032068 out_ERR032071 
		>do
		>tophat -r 36 -o tophat_$x s_mediterranea-BCN10 $x'_1'.fq, $x'_2'.fq
		>done
		
Example output in align_summary.txt:

	Left reads:
        	  Input     :   2000000
        	   Mapped   :    988245 (49.4% of input)
        	    of these:    124974 (12.6%) have multiple alignments (444 have >20
	Right reads:
        	  Input     :   2000000
        	   Mapped   :    967467 (48.4% of input)
        	    of these:    121569 (12.6%) have multiple alignments (444 have >20
	48.9% overall read mapping rate.

	Aligned pairs:    871802
	     of these:    109491 (12.6%) have multiple alignments
        	             704 ( 0.1%) are discordant alignments
	43.6% concordant pair alignment rate.
 
 (much better than the 2 reads aligned from 200000 of that tried earlier) --> try to align in IGV later?
 
 **NEED TECHNICAL REPLICATES** to perform Sleuth (the output is empty right now)
 
 To do this, I'm going to downsample the data a second time with a different random variable in seqtk
 
 (Will delete everything and rerun)

made and ran preprocessing script, then updated and ran the other scripts (kallisto --> pearson --> sleuth --> tophat)

*Kallisto settings:*
	
	fragment length distribution will be estimated from the data
	k-mer length: 31
	number of targets: 42,590
	number of k-mers: 19,007,004
	number of equivalence classes: 64,422
	running in paired-end mode
	number of EM bootstraps complete: 100

*Kallisto Output:*

**ERR032066_1_REP1.fq & ERR032066_2_REP1.fq**

processed 1,000,000 reads, 495,427 reads pseudoaligned\
estimated average fragment length: 76.7095\
the Expectation-Maximization algorithm ran for 648 rounds

**ERR032066_1_REP2.fq & ERR032066_2_REP2.fq**

processed 1,000,000 reads, 495,692 reads pseudoaligned\
estimated average fragment length: 76.7074\
the Expectation-Maximization algorithm ran for 576 rounds


**ERR032068_1_REP1.fq & ERR032068_2_REP1.fq**

processed 1,000,000 reads, 510,969 reads pseudoaligned\
estimated average fragment length: 87.1406\
the Expectation-Maximization algorithm ran for 597 rounds

**ERR032068_1_REP2.fq & ERR032068_2_REP2.fq**

processed 1,000,000 reads, 510,792 reads pseudoaligned\
estimated average fragment length: 86.9835\
the Expectation-Maximization algorithm ran for 887 rounds

**ERR032071_1_REP1.fq & ERR032071_2_REP1.fq**

processed 1,000,000 reads, 513,705 reads pseudoaligned\
estimated average fragment length: 65.4637\
the Expectation-Maximization algorithm ran for 648 rounds

**ERR032071_1_REP2.fq & ERR032071_2_REP2.fq**

processed 1,000,000 reads, 515,140 reads pseudoaligned\
estimated average fragment length: 65.4439\
the Expectation-Maximization algorithm ran for 655 rounds


*Pearson's Score Results:*

||ERR032066_REP1|ERR032066_REP2|ERR032068_REP1|ERR032068_REP2|ERR032071_REP1|ERR032071_REP2|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|ERR032066_REP1|1|0.98610539087985|0.95253427619665|0.9464028951102|0.90544261250207|0.90526620250837|
|ERR032066_REP2|-|1|0.95552431638534|0.95555170195661|0.90445384507567|0.90736691970725|
|ERR032068_REP1|-|-|1|0.98021528481508|**0.8560203652387**|**0.8507750455639**|
|ERR032068_REP2|-|-|-|1|**0.85767677186221**|**0.86079413672383**|
|ERR032071_REP1|-|-|-|-|1|0.97894030879385|
|ERR032071_REP2|-|-|-|-|-|1|
 
## 6.7.18
sorted and indexed bam files outputted from tophat for IGV visualization:

	samtools sort accepted_hits.bam > sort_accepted_hits.bam 
	samtools index sort_accepted_hits.bam 

In IGV --> Tools > run igvtools > Count on the sorted bam files from tophat to make .tdf files

Visualized these in IGV

also: http://smedgd.stowers.org/downloads/ too use (may need to redo everything using the data here as reference genomes/genome annotations)

	head -n 11  sleuth_results.tab | awk '{print $2}'
	test_stat
	AAA.ABI.14220
	AAA.ABI.20112
	AAA.ABI.15885
	AAA.ABI.4229
	AAA.ABI.22662
	AAA.ABI.39389
	AAA.ABI.41399
	AAA.ABI.42381
	AAA.ABI.42149
	AAA.ABI.13080

## 6.9.18

Decided to redo analysis using http://smedgd.stowers.org/files/Smed_unigenes_20150217.nt.gz as the index for kallisto + tophat

This allows for a later GO analysis using SmedGD: http://smedgd.stowers.org/cgi-bin/searchGO.pl

Made an index in kallisto with `kallisto index -i s_mediterranea_unigene Smed_unigenes_20150217.nt.gz`

	[build] loading fasta file Smed_unigenes_20150217.nt.gz
	[build] k-mer length: 31
	[build] counting k-mers ... done.
	[build] building target de Bruijn graph ...  done
	[build] creating equivalence classes ...  done
	[build] target de Bruijn graph has 89300 contigs and contains 28790186 k-mers

Kallisto script output: (much better mapping with this)

	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 32,615
	[index] number of k-mers: 28,790,186
	[index] number of equivalence classes: 44,052
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032066_1_REP1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032066_2_REP1.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 1,000,000 reads, 606,459 reads pseudoaligned
	[quant] estimated average fragment length: 76.7247
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 835 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 32,615
	[index] number of k-mers: 28,790,186
	[index] number of equivalence classes: 44,052
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032066_1_REP2.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032066_2_REP2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 1,000,000 reads, 606,376 reads pseudoaligned
	[quant] estimated average fragment length: 76.578
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 830 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 32,615
	[index] number of k-mers: 28,790,186
	[index] number of equivalence classes: 44,052
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032068_1_REP1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032068_2_REP1.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 1,000,000 reads, 627,391 reads pseudoaligned
	[quant] estimated average fragment length: 86.7148
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 745 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 32,615
	[index] number of k-mers: 28,790,186
	[index] number of equivalence classes: 44,052
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032068_1_REP2.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032068_2_REP2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 1,000,000 reads, 627,218 reads pseudoaligned
	[quant] estimated average fragment length: 86.7246
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 846 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 32,615
	[index] number of k-mers: 28,790,186
	[index] number of equivalence classes: 44,052
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032071_1_REP1.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032071_2_REP1.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 1,000,000 reads, 638,029 reads pseudoaligned
	[quant] estimated average fragment length: 65.8377
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 785 rounds
	[bstrp] number of EM bootstraps complete: 100


	[quant] fragment length distribution will be estimated from the data
	[index] k-mer length: 31
	[index] number of targets: 32,615
	[index] number of k-mers: 28,790,186
	[index] number of equivalence classes: 44,052
	[quant] running in paired-end mode
	[quant] will process pair 1: /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032071_1_REP2.fq
								 /home/linux/ieng6/cs185s/cs185sbe/cse185-final-proj                                                                                            ect-eeelinn/analysis_reads/ERR032071_2_REP2.fq
	[quant] finding pseudoalignments for the reads ... done
	[quant] processed 1,000,000 reads, 638,437 reads pseudoaligned
	[quant] estimated average fragment length: 65.9079
	[   em] quantifying the abundances ... done
	[   em] the Expectation-Maximization algorithm ran for 845 rounds
	[bstrp] number of EM bootstraps complete: 100

Sleuth Output:

	head -n 11  sleuth_results.tab | awk '{print $2}'
	test_stat
	SMU15001354 (http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15001354)
	SMU15013634
	SMU15040569
	SMU15032328
	SMU15014313
	SMU15033139
	SMU15037874
	SMU15000129
	SMU15017076
	SMU15028330

Pearson Score:

||ERR032066_REP1|ERR032066_REP2|ERR032068_REP1|ERR032068_REP2|ERR032071_REP1|ERR032071_REP2|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|ERR032066_REP1|1|0.99840867249613|0.98221839233625|0.98324639210027|0.98085494713689|0.9812099421827|
|ERR032066_REP2|-|1|0.98301484188427|0.9839724863457|0.98092760577249|0.98132655479105|
|ERR032068_REP1|-|-|1|0.99852040623394|0.97855275683916|0.97773164073777|
|ERR032068_REP2|-|-|-|1|0.97847013780285|0.97790184046369|
|ERR032071_REP1|-|-|-|-|1|0.9984051372093|
|ERR032071_REP2|-|-|-|-|-|1|

unzipped the smed_unigene fasta file --> `gunzip Smed_unigene_20150217.nt.gz`

indexed with bowtie2: `bowtie2-build Smed_unigene_20150217.nt s_mediterranea`
ran tophat script



## Tools Downloaded

**seqtk**
 
	git clone https://github.com/lh3/seqtk.git
	cd seqtk 
	make

**TopHat**

	wget https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz
	tar -xvzf tophat-2.1.1.Linux_x86_64.tar.gz

**Bowtie**

Downloaded from the web at https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.1/bowtie2-2.3.4.1-linux-x86_64.zip/download

then

	unzip bowtie2-2.3.4.1-linux-x86_64

## Manuals

https://ccb.jhu.edu/software/tophat/manual.shtml (Tophat)

https://ccb.jhu.edu/software/tophat/tutorial.shtml#ref (tophat tutorial)
