# Scripts for Analysis of NPCdiff ATAC-Me data

|Required Packages|
|---------------|
|SAMtools/1.9   |  
|BEDTools/2.28.0|
|BamTools/2.5.1 |    
|Anaconda3/5.0.1|
|GSL/2.5        | 
|GCC/8.2.0      |

A general outline for ATAC-Me data processing was published as part of our [protocol paper](https://www.nature.com/articles/s41596-021-00608-z) and can also be found on our [GitHub page](https://github.com/HodgesGenomicsLab/NatProtocols_ATACme).

The first step for ATAC-Me data processing begins with fastq files which are [trimmed](ATACme_processing/trim.slrm) prior to starting the methylation analysis pipeline of [DNMTools](https://github.com/smithlabcode/dnmtools) (formally MethPipe) see in the [methprocess.slrm](ATACme_processing/methprocess.slrm). Resulting files contain methylation quantification for symmetric CpGs. 

Accessibility analysis takes place after methylation quantification as this pipeline utilized an aligment method capable of working with bisulfite converted reads. The resulting aligned reads are [filtered](ATACme_processing/bam_filter.slrm) for quality. To call accessible peaks in these libraries we used the [Genrich](https://github.com/jsh58/Genrich) peak caller as outlined in the [genrich.slrm](ATACme_processing/genrich.slrm) script. 

A consensus bed file of accessible peaks was made by concatenating peak calls from all timepoints and merging overlapping regions using [bedtools merge](https://bedtools.readthedocs.io/en/latest/content/tools/merge.html) with default settings. The read counts of all samples at all regions in this consensus peak file were found through application of [featureCounts](https://academic.oup.com/bioinformatics/article/30/7/923/232889?login=true), as seen [here](ATACme_processing/featureCounts.slrm). 

Average regional methylation can be quantified across any .bed file of interest and was performed many times throughout this manuscript. An example of such analysis can be found [here](ATACme_processing/roimethstat.slrm). 

The methylation and accessibility files produced from the above steps are the basis of all subsequent analyses. 

## Figure 1
## Figure 2
## Figure 3
## Figure 4
## Figure 5
## Figure 6
