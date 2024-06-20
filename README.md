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

Accessibility analysis is very similar to ATAC-seq analysis but must begin with an aligment method capable of working with bisulfite converted reads. We used [WALT](https://github.com/smithlabcode/walt), which is now deprecated and has been replaced with [abismal](https://github.com/smithlabcode/abismal). The resulting aligned reads are [filtered](ATACme_processing/bam_filter.slrm) for quality. To call accessible peaks in these libraries we used the [Genrich](https://github.com/jsh58/Genrich) peak caller as outlined in the [genrich.slrm](ATACme_processing/genrich.slrm) script. 

A consensus bed file of accessible peaks was made by concatenating peak calls from all timepoints and merging overlapping regions using [bedtools merge](https://bedtools.readthedocs.io/en/latest/content/tools/merge.html) with default settings. The read counts of all samples at all regions in this consensus peak file were found through application of [featureCounts](https://academic.oup.com/bioinformatics/article/30/7/923/232889?login=true), as seen [here](ATACme_processing/featureCounts.slrm). 

Average regional methylation can be quantified across any .bed file of interest and was performed many times throughout this manuscript. An example of such analysis can be found [here](ATACme_processing/roimethstat.slrm). 

The methylation and accessibility files produced from the above steps are the basis of all subsequent analyses. 

# Scripts for Analysis of NPCdiff RNAseq data

|Required Packages|                    |
|---------------|---------------------
|SAMtools/1.9   | featureCounts v2.0.0
|BEDTools/2.28.0|
|BamTools/2.5.1 |    
|Anaconda3/5.0.1|
|GSL/2.5        | 
|GCC/8.2.0      |
|STAR 2.6.1b    |
|picard/2.18.27 |
|zlib/.1.2.11   |
# Scripts for Figure Generation
## Figure 1
### B: scRNA-seq
Data analysis of scRNA-seq was done in collaboration with the Lau Lab at Vanderbilt University and all associated analysis code can be found here.

### C: Data Visualization
Data tracks for methylation and accessibility were generated, [here](Figure1_scripts/fig1C_make_bw_tracks.slrm), and uploaded to CyVerse for visualization on the UCSC Genome Browser.<br> 
<ins>Input</ins><br>
filtered bams were the input for accessibility<br> .meth files filtered for a CpG read coverage $\ge$ 5 were input for methylation 

### D: deeptools Heatmaps
deeptools heatmaps were generated for dynamic and static regions, [here](Figure1_scripts/fig1D_deeptools_heatmap.slrm). Dynamic regions were identified using TC-seq as explained in figure 2. <br>
<ins>Input</ins><br>
accessibility and methylation bigWigs (fig1C)<br>
.bed files of regions of interest

### E: Region Annotation
Both dynamic and static regions were annotated based on their localization in the genome, [here](Figure1_scripts/fig1E_region_annotation.Rmd).<br>
<ins>Input</ins><br>
.bed files of regions of interest

## Figure 2
### A: TCseq Clustering and Visualization
Accessible regions were clustered based on temporal behavior using [TCseq](Figure2_scripts/fig2A_TCseq.Rmd), and visualized using deepTools and ggplot2. The cluster number was determined using the code found [here](Figure2_scripts/supp2A_B_C_TC_gap.R).<br>
<ins>Input</ins><br>
filtered accessibility signal .bams for each timepoint replicate and consensus peak list

### B and C: ChromHMM Annotation
Regions were annotated to 18-state ChromHMM annotations at the ESC (H9) and NPC stage downloaded from [ENCODE](https://www.encodeproject.org/matrix/?type=Annotation). Regions were intersected with annotation regions as seen [here](Figure2_scripts/fig2B_C_chromHMM.sh).<br>
<ins>Input</ins><br>
Dynamic clustered region .bed files from TCseq<br>
annotation .bed file from ENCODE

### D: Motif Enrichment Heatmaps
Motif enrichment was performed on regions within each TCseq cluster using [HOMER](Figure2_scripts/fig2d_HOMER.slrm). Enrichment was visualized using pheatmap, scaling fold-change enrichment by TF across clusters as detailed [here](Figure2_scripts/fig2D_pheatmap.Rmd). CpG likelihood of each motif was calculated using [motto](https://github.com/MichaelMW/motto). <br>
<ins>Input</ins><br>
clustered accessibility .bed list<br>

## Figure 3
### A: Dual Axis Data Integration

### B: Methylation Change

### C: Sankey Visualization

### D: deepTools Visualization

### E: 6-base Methylation Quantification


## Figure 4
## Figure 5
## Figure 6
