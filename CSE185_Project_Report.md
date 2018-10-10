# RNA-Sequencing Differential Gene Expression and GO Analysis of Potential Genes Involved in *Schmidtea mediterranea* Brain Regeneration Regulation
#### by Erikka Linn

## Abstract
This project investigated the regeneration of brain tissue in the Planarian *Schmidtea mediterranea*. Ideally, this project would pinpoint what gene(s) regulate regeneration and whether the expression of such differs from humans which cannot reproduce neurons well. The medical applications of this are powerful since induced neurogenesis can better rehabilitate individuals suffering traumatic brain injuries than current treatments. Differential gene expression and genomic visualization were performed. Interestingly, older regenerative brain tissue better resembled the genomic expression of non-regenerative tissue when compared to fresher regenerative brain tissue. Furthermore, SMU15013634 and SMU15032328 were identified as two promising genomic regions that warrant deeper research.

## Introduction
Planarians have amazing regeneration powers as they can create clones of themselves complete with a new functional brain from a small piece of tissue [1]. As such, planarian species such as *Schmidtea mediterranea* are being researched as model organisms for brain regeneration. In contrast, humans are unable to restore lost neural tissue which is thought to be the main reason individuals suffer immensely from brain injuries/diseases [2]. The medical importance in developing a way to induce neurogenesis is enormous and is the motivation behind much research surrounding the regulation of brain regeneration.

To determine a potentional mechanism for how brain regeneration is regulated, the RNA-seq data of different tissue samples collected in a previous study will be used. The analyses will look at *S. mediterranea* regenerative brain tissues from two different periods of time from the tissue being cut and a third sample of non-regenerative tissue to see what expression differences there may be between all three sample types [3]. Since there were no known species specific genes at the time of this study, the two gene-like regions (smed-egr-like1 and smed-runt-like1) it identified were simply hunches and published with a disclaimer waiting for others to verify similar results [3].

Nevertheless, it has been nearly a decade since the study with the datasets has been published. In that time, numerous projects have been performed with this species and many genes such as egr4 have been explored [4]. Additionally, efforts for data compilations have been successful with sites like SmedGD. Though, there is not that much information out there on genes specific to this species and their functions, enough data has been sequenced between multiple samples that unigenes have been characterized. Unigenes are clusters of similar amino acid sequences, some with putative functions determined bioinformatically by comparisons from other genome databases such as Swissprot and enSEMBL [5]. As such, a differential unigene analysis and visualization can identify specific genomic regions with a potential role in brain regeneration regulation. These identified genomic regions would help pinpoint areas where further experimention about their functions would be worthwhile to pursue in future studies.

## Methods
### Dataset Pre-Processing and Quality Checks
Three RNA-seq Illumina paired-end samples from the *S. mediterranea* (clonal line BCN-10) were sequenced and can be found at 
[[E-MTAB-607]( http://dev.biologists.org/content/141/9/1835.figures-only)] [3]. Each library corresponds to tissues sequenced 
at different time periods from being cut. Libraries 1 (ERR032066: regenerative tissue, 30 min - 1 h), 3 (ERR032068: regenerative 
tissue, 4 - 8 h), and 6 (ERR032071: non-regenerative tissue, 0 h) were used in this project. Additionally the Reference Smed 
Unigene Nucleotide FASTA, [Smed_unigenes_20150217.nt.gz](http://smedgd.stowers.org/downloads/) [5], was used to index and 
align the experimental reads. 

The [preprocess_data.sh](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/scripts/preprocess_data.sh) 
script was developed to automate the following pre-processing and quality checks portion of the pipeline. The libraries were 
down-sampled to 5% (1,000,000 reads of length 36 bp per sample) from their original size with `seqtk` [v0.2.7] options 
`-s100 10000000` for each pair of technical replicates 1 reads and `-s200 1000000` for each pair of technical replicates 
2 reads per library [6]. This was done so that the dataset would not surpass the 2GB memory limitation of the server. Additionally, `Fastqc` [v 0.11.7] was run with default options on each newly down-sampled read to check its quality [7]. 

### Quantification and Alignment
Before quantifying the reads, an index `s_mediterranea_unigene` was made with the reference file `Smed_unigenes_20150217.nt.gz` 
in `kallisto` [v 0.44.0] using default `index` options [8]. Then, the 
[run_kallisto_final.sh](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/scripts/run_kallisto_final.sh) 
script was used to automate `Kallisto` quantification with options `-t 3 -b 100` and the newly created index.`bowtie2-build` [v 2.2.9] 
was used on the unzipped `Smed_unigenes_20150217.nt` FASTA reference file to produce the `s_mediterranea` index necessary for `tophat` 
[v 2.1.1] alignment [10, 11]. Alignment for later visualization was done using the 
[run_tophat.sh](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/scripts/run_tophat.sh) script that 
used option `-r 36` for each library.

### Analyses and Visualization
Pearson’s scores were calculated using the 
[pearsonscore.sh](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/scripts/pearsonscore.sh) script. In 
it, `Datamash` [v 1.3] with command and option `ppearson 2:1` was run on the abundance.tsv files generated from the previous `kallisto` 
quantification [11]. The [DGE_sleuth.r](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/scripts/DGE_sleuth.r) 
script which uses `sleuth` [v 1.3] was run on the `kallisto` output to perform a differential gene expression analysis [12, 8]. The top 
ten differentially expressed unigenes were then extracted and a GO analysis was done using the WebApp 
[SmedGD](http://smedgd.stowers.org/cgi-bin/searchGO.pl) [v 2.0] [5]. Finally, the `accepted_hits` file from the `tophat` alignment 
were sorted and indexed with default options in `samtools` [v 1.5] before they were converted to `.tdf` files with IGVtools [v 2.4.10] 
[13]. These `.tdf` files were then visualized in IGV [v 2.4.10] to see if there were any trends or areas worth looking into in the 
future [14].

## Results
### RNA-seq Analysis and Visualization
`Fastqc` verified that the libraries used were of good quality. Each sample's PDF report can be found in the [FastQC]
(https://github.com/cse185-sp18/cse185-final-project-eeelinn/tree/master/fastqc) folder. The two regenerative tissue samples were the 
most similar of the three tissue types. Overall, the RNA-seq replicates were very comparable with a pearsons score at or slightly above 
0.99 for all tissue sample replicates. Additionally, samples had high pearsons scores calculated to be above 0.97 and can be seen in 
Figure 1. There were 52 total significant differentially expressed transcripts. Screenshots of the top 10 from IGV are shown in the 
figures section below (Figures 2 - 11). There was a noticeable difference in RNA-seq expression between tissue ER032066 compared to both 
ERR032068 and ERR032071 in unigenes SMU15001354, SMU15013634, SMU15032328, SMU15014313, and SMU15037874. Of these, only SMU15001354 had 
the ERR032066 tissue with the highest coverage whereas it had the lowest expression in all other visualized locations.

## GO Analysis
A GO analysis of the top 10 Sleuth results was done in the SmedGD webapp.
[SMU15001354](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15001354) is a putative heat shock protein and may be related to the
YBL075C gene in *H. Sapiens*. Additionally, this may play a role in protein folding, the stress response, and SRP-dependent targeting
and translocation of cotranslational protein-membranes.
Both [SMU15032328](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15032328) and 
[SMU15014313](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15014313) are putative macrophage mannose receptors similar to the 
ENSP00000455897 and MRC1_HUMAN genes in *H. Sapiens* which are thought to play a role in the production of inflammatory cytokines. 
[SMU15013634](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15013634) is a putative steryl ester hydrolase similar to the 
YKL140W gene in *H. Sapiens* which is localized to lipid particle membranes and may be involved in sterol homeostasis.
However, [SMU15040569](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15040569), 
[SMU15037874](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15037874), 
[SMU15000129](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15000129), 
[SMU15017076](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15017076), and 
[SMU15033139](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15033139) have no known function and currently are not related to 
known genes in any other model organism.
Though the exact classification of [SMU15028330](http://smedgd.stowers.org/cgi-bin/genePage.pl?ref=SMU15028330) is also unknown, it has been related to a variety of known genes such as AAL29937.1	of *Girardia tigrina*, PLC_HALLA, FBpp0072555, and ENSP00000332723 in *H. Sapiens*, and F52E1.2 in *C. elegans*. 

## Figures
**Figure 1: Pearson Scores**

||ERR032066_REP1|ERR032066_REP2|ERR032068_REP1|ERR032068_REP2|ERR032071_REP1|ERR032071_REP2|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|ERR032066_REP1|1|0.99840867249613|0.98221839233625|0.98324639210027|0.98085494713689|0.9812099421827|
|ERR032066_REP2|-|1|0.98301484188427|0.9839724863457|0.98092760577249|0.98132655479105|
|ERR032068_REP1|-|-|1|0.99852040623394|0.97855275683916|0.97773164073777|
|ERR032068_REP2|-|-|-|1|0.97847013780285|0.97790184046369|
|ERR032071_REP1|-|-|-|-|1|0.9984051372093|
|ERR032071_REP2|-|-|-|-|-|1|

**Figure 2: SMU15001354**
![SMU15001354](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15001354.jpg)
**Figure 3: SMU15013634**
![SMU15013634](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15013634.jpg)
**Figure 4: SMU15040569**
![SMU15040569](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15040569.jpg)
**Figure 5: SMU15032328**
![SMU15032328](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15032328.jpg)
**Figure 6: SMU15014313**
![SMU15014313](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15014313.jpg)
**Figure 7: SMU15033139**
![SMU15033139](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15033139.jpg)
**Figure 8: SMU15037874**
![SMU15037874](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15037874.jpg)
**Figure 9: SMU15000129**
![SMU15000129](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15000129.jpg)
**Figure 10: SMU15017076**
![SMU15017076](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15017076.jpg)
**Figure 11: SMU15028330**
![SMU15028330](https://github.com/cse185-sp18/cse185-final-project-eeelinn/blob/master/IGV%20Images/SMU15028330.jpg)


## Discussion
The data suggests that most of the significantly identified unigenes were suppressed immediately after tissue injury and overexpressed later on in the regeneration process. It is interesting to note that the older regenerative tissue shared a better transcript expression resemblence with the non-regenerative tissue than with the fresher regenerative tissue. The only identified unigene where the fresh regenerative tissue had the highest expression was with the putative heat shock protein SMU15001354. A potential explanation for this could be that most of the energy and resources in the tissue are directed to the inflammatory/stress response thie protein stimulates to maintain homeostasis and stabilize the original tissue [15]. Once stable, cellular resources and energy would then be directed towards other unigenes. These are then overexpressed so that they can foster growth and regeneration from the piece of cut/injured tissue. Over time, it's expected that the expression levels of these unigenes taper off until they hit the threshold necessary for sustaining life. 

From the unigenes significantly identified, it would also be worthwhile to look into unigenes SMU15013634 and SMU15032328 because these areas showed differences between all three tissue types where the older regenerative tissue had a noticeable upuregulation. Additionally, these two genes have putative functions already known to be involved in tissue regeneration. SMU15032328 is a putative macrophage mannose receptor known to play a role in the production of inflammatory cytokines in other species [16]. An increase in pro-inflammatory cytokine production has been linked with the signaling pathways for neural and liver regeneration in humans [16, 17]. As such, the overexpression of this unigene could be one of the genetic regulators for the brain regeneration in this species. 

In addition to this, the SMU15013634 unigene is a putative steryl ester hydrolase that is localized to lipid particle membranes and may be involved in sterol homeostasis. Lipids are known to be highly concentrated in the central nervous system for most animals as it is important in maintaining homeostasis and brain development [18]. Additionally, sterol regulation has been tied to tissue differentiation, regeneration, and aging pathways as well as many degenerative brain diseases/injuries [18]. This could potentially be improved by the increased expression of this unigene that influences sterol production and regulation. Thus, this could also be another way brain regeneration is regulated.

Future studies should use more samples with shorter time increments between so the point at which the unigene underexpression transitions to overexpression can be determined and further analyzed. Likewise, more research should be done on both the function of unigenes SMU15013634 and SMU15032328 as well as the regulation of these unigenes. Since all tissue samples expressed both unigenes, the enhancer regions for these unigenes should also be located and studied to see if a specific mutation in the genetic code may be the culprit to regulating brain regeneration.

## Citations
1.	Umesono, Yoshihiko, and Kiyokazu Agata. "Evolution and regeneration of the planarian central nervous system." Development, growth & differentiation 51.3 (2009): 185-195.
2.	Eriksson, Peter S., et al. "Neurogenesis in the adult human hippocampus." Nature medicine 4.11 (1998): 1313.
3.	Sandmann, Thomas, et al. "The head-regeneration transcriptome of the planarian Schmidtea mediterranea." Genome biology 12.8 (2011): R76.
4.	Susanna Fraguas, Sara Barberán, Marta Iglesias, Gustavo Rodríguez-Esteban, Francesc Cebrià. “egr-4, a target of EGFR signaling, is required for the formation of the brain primordia and head regeneration in planarians” Development 2014 141: 1835-1847; doi: 10.1242/dev.101345
5.	Robb SM, Gotting K, Ross E, Sánchez Alvarado A., SmedGD 2.0: The Schmidtea mediterranea genome database., Genesis 2015 Jul [Epub ahead of print]
6.	Seqtk, version 0.2.7 Copyright (c) 2008-2012 by Heng Li <lh3@me.com>. Available at: https://github.com/lh3/seqtk 
7.	FastQC: a quality control tool for high throughput sequence data, version 0.11.7 by Andrews S. (2010). Available at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc 
8.	Bray, N. L., Pimentel, H., Melsted, P. & Pachter, L. Near-optimal probabilistic RNA-seq quantification, Nature Biotechnology 34, 525-527(2016), doi:10.1038/nbt.3519
9.	Bowtie 2, version 2.2.9 by Ben Langmead (langmea@cs.jhu.edu, www.cs.jhu.edu/~langmea). Available at: https://sourceforge.net/projects/bowtie-bio/files/bowtie2/ 
10.	Tophat, version 2.1.1 by Kim, D., Pertea, G., Trapnell, C., Pimentel, H., Kelley, R. and Salzberg S. “TopHat2: accurate alignment of transcriptomes in the presence of insertions, deletions and gene fusions”. Ge-nome Biology. 14:R36. 2013. Available at: https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz 
11.	Datamash (GNU datamash) 1.3, Copyright (C) 2018 Assaf Gordon, License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
12.	Harold J. Pimentel, Nicolas Bray, Suzette Puente, Páll Melsted and Lior Pachter, Differential analysis of RNA-Seq incorporating quantification uncertainty, Nature Methods (2017), advanced access http://dx.doi.org/10.1038/nmeth.4324 
13.	Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9. [PMID: 19505943]
14.	James T. Robinson, Helga Thorvaldsdóttir, Wendy Winckler, Mitchell Guttman, Eric S. Lander, Gad Getz, Jill P. Mesirov. Integrative Genomics Viewer. Nature Biotechnology 29, 24–26 (2011)
15. Morimoto, Richard I., et al. "The heat-shock response: regulation and function of heat-shock proteins and molecular chaperones." Essays in biochemistry 32 (1997): 17-29.
16. Strey, Christoph W., et al. "The proinflammatory mediators C3a and C5a are essential for liver regeneration." Journal of Experimental Medicine 198.6 (2003): 913-923.
17. Ben-Hur, Tamir, et al. "Effects of proinflammatory cytokines on the growth, fate, and motility of multipotential neural precursor cells." Molecular and Cellular Neuroscience 24.3 (2003): 623-631.
18. Adibhatla, Rao Muralikrishna, and James F. Hatcher. "Role of lipids in brain injury and diseases." Future lipidology 2.4 (2007): 403-422.
19. Wollam, Joshua, and Adam Antebi. "Sterol regulation of metabolism, homeostasis, and development." Annual review of biochemistry 80 (2011): 885-916.
