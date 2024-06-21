# Scripts for Data Analysis 
|Required Packages|              |
|---------------|--------------- 
|SAMtools/1.9   |Genrich/version 0.6
|BEDTools/2.28.0|featureCounts v2.0.0
|BamTools/2.5.1 |picard/2.18.27     
|Anaconda3/5.0.1|WALT v1.0
|GSL/2.5        |methpipe-5.0.1
|GCC/8.2.0      |STAR 2.6.1b   
|zlib/.1.2.11   |

A general outline for ATAC-Me data processing was published as part of our [protocol paper](https://www.nature.com/articles/s41596-021-00608-z) and can also be found on our [GitHub page](https://github.com/HodgesGenomicsLab/NatProtocols_ATACme).

The first step for ATAC-Me data processing begins with fastq files which are [trimmed](ATACme_processing/trim.slrm) and [mapped](ATACme_processing/walt.slrm) (WALT, see below) prior to starting the methylation analysis pipeline of [DNMTools](https://github.com/smithlabcode/dnmtools) (formally MethPipe) see in the [methprocess.slrm](ATACme_processing/methprocess.slrm). Resulting files contain methylation quantification for symmetric CpGs. 

Accessibility analysis is very similar to ATAC-seq analysis but must begin with an aligment method capable of working with bisulfite converted reads. We used [WALT](https://github.com/smithlabcode/walt), which is now deprecated and has been replaced with [abismal](https://github.com/smithlabcode/abismal). The resulting aligned reads are [filtered](ATACme_processing/bam_filter.slrm) for quality. To call accessible peaks in these libraries we used the [Genrich](https://github.com/jsh58/Genrich) peak caller as outlined in the [genrich.slrm](ATACme_processing/genrich.slrm) script. 

A consensus bed file of accessible peaks was made by concatenating peak calls from all timepoints and merging overlapping regions using [bedtools merge](https://bedtools.readthedocs.io/en/latest/content/tools/merge.html) with default settings. The read counts of all samples at all regions in this consensus peak file were found through application of [featureCounts](https://academic.oup.com/bioinformatics/article/30/7/923/232889?login=true), as seen [here](ATACme_processing/featureCounts.slrm). 

Average regional methylation can be quantified across any .bed file of interest and was performed many times throughout this manuscript. An example of such analysis can be found [here](ATACme_processing/roimethstat.slrm). 

The methylation and accessibility files produced from the above steps are the basis of all subsequent analyses. 
  
All scripts for processing of RNA-seq, scRNA-seq, and 6-base evoC data are included in their respective folders. 

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
Methylation was calculated at accessible peaks using roimethstat as detailed [here](Figure3_scripts/dynamic_roimethstat.slrm). Accessibility signal at cluster peak regions was calculated using [featureCounts](ATACme_processing/featureCounts.slrm). Visualization was performed using ggpot2 as shown [here](Figure3_scripts/fig3A_dualAxisplot.Rmd). <br>
<ins>Input</ins><br>
for methylation: .meth files from [methprocess.slrm](ATACme_processing/methprocess.slrm) and region .bed files for each cluster<br>
for accessibility: filtered .bam files and region .bed files for each cluster<br>

### B: Methylation Change
Regional methylation, previously quatified, was read in for all accessible dynamic clusters. Methylation change was placed into three categories, "lose", "stable", and "gain" based on the difference in regional methylation from the beginning to the end of the timecourse. 

### C: Sankey Visualization
Regions were grouped by their overall methylation trend and overall accessibility trend for the timecourse. Methylation categories were preserved from 3B. Accessibility clusters <i>Gradual Opening</i> and <i>Late Opening</i> comprised the Opening group. <i>Gradual Closing</i> and <i>Delayed Closing</i> made up the Closing group. Remaining clusters were termed Transient.

### D: deepTools Visualization
Visualization was performed as noted in 1D with differing input region .bed files. Regions were grouped by both their methylation and accessibility patterns with each combination comprising a unique .bed file. <br>
<ins>Input</ins><br>
combination .bed files <br>
methyation and accessibility .bw 

### E: 6-base Methylation Quantification
modC data was  extracted from 6-base data following initial processing using modality. The modC data at each timepoint was intersected with accessible peak cluster regions and averaged across all CpG sites in the region. Subsequent processing and visualization was done in R, [here](Figure3_scripts/fig3E_mC_quant.Rmd). 

## Figure 4
### A and B: deepTools Visualization
Footprint sites were determined using [TOBIAS](Figure4_scripts/fig4_TOBIAS.slrm), and bound sites were intersected with dynamic accessible regions. Footprint regions were grouped by their accessibility patterns. Methylation tracks were the same signal .bw used previously and cutsite .bw were generated, [here](Figure4_scripts/fig4A_cutsitebw.slrm). Visualization using deepTools is detailed, [here](Figure4_scripts/fig4AB_footprintheatmap.slrm).<br>
<ins>Input</ins><br>
footprint site .bed files <br>
methyation and cut site .bw 

### C: TF Expression
Differentially expressed transcription factor genes were plotted as a heatmap. Differential gene expression was determined using [DESeq2](RNAseq_processing/NPCdiff_DESeq2.Rmd). Significantly differentially expressed genes that were also listed in the [FANTOM SSTAR database](https://fantom.gsc.riken.jp/5/sstar/Main_Page) as a TF were graphed. <br>

### D and E: Footprint Methylation
Regional methylation was calculated for all bound transcription factor binding sites. The regional methylation was calculated using the [roimethstat](ATACme_processing/roimethstat.slrm) script mentioned above. <br>
<ins>Input</ins><br>
footprint site .bed files, filtered by binding state at each timepoint <br>
merged .meth files for each timepoint <br>

## Figure 5
### A: Global 5-hmC ELISA
Global 5-hmC was measured via ELISA and quantified via standard curve. %hmC values at each timepoint are visualized via ggplot2.

### B: Cell Cycle 5-hmC
Median signal intensity was measured for gated populations (cell cycle stages) at each timepoint using Cytobank. Cell cycle stages were determined by PI and BrdU staining. Within each timepoint and biological replicate, the intensity values were normalized to the minimum population and represented as a transformed ratio. The transformed ratio is plotted for each sample using ggplot2 as outlined [here](Figure5_scripts/fig5B_cellcycle.Rmd). <br>
<ins>Input</ins><br>
median signal intensity for 5-hmC

### C:Global 5-hmC 6-base
The fraction of reads reporting 5-hmC over total reads for each CpG site were calculated from 6-base sequencing data. The 5-hmC fraction was then averaged across all dynamic peaks at each timepoint and between biological replicates. The boxplot shows the distribution of regional average 5-hmC fraction at each timepoint for all dynamic regions. The points represent the regional average 5-hmC for each replicate independently. Visualization code is shown [here](Figure5_scripts/fig5C_total5hmCquant.Rmd).
<ins>Input</ins><br>
.bed files for dynamic regions <br>
dataframe containing fraction 5-hmC <br>

### D: 5-hmC Fraction by Accessibility Cluster
Average 5-hmC fraction across regions was calculated as in Figure 5C, however the data is faceted by accessibility cluster, including static regions. Visualization code is shown [here](Figure5_scripts/fig5D_5hmCquant.Rmd).
<ins>Input</ins><br>
.bed files for dynamic accessibility clusters <br>
.bed files for static regions <br>
dataframe containing fraction 5-hmC <br>

### E: 5-hmC Traces
The 5-hmC fraction at CpG sites within selected regions are shown for each timepoint. Signal is an average between two biological replicates. Visualization is produced by [Modality](Figure5_scripts/fig5EF_modality.ipynb). <br>
<ins>Input</ins><br> 
zarr file for 6-base sequencing data <br>

### F: 5-mC Traces
The 5-mC fraction at CpG sites within selected regions are shown for each timepoint. Signal is an average between two biological replicates. Visualization is produced by [Modality](Figure5_scripts/fig5EF_modality.ipynb). <br>
<ins>Input</ins><br>
zarr file for 6-base sequencing data <br>

### G: 5-hmC Changes over Time
The fraction of reads reporting 5-hmC over total reads for each CpG site were calculated from 6-base sequencing data. The 5-hmC fraction was then averaged across all peaks at each timepoint and between biological replicates. The difference between averages were across timepoints. Data was faceted by dynamic accessibility cluster. Visualization code is shown [here](Figure5_scripts/fig5G_S5E_delta5hmC.Rmd).<br>
<ins>Input</ins><br>
.bed files for dynamic accessibility clusters <br>
dataframe containing fraction 5-hmC <br>

### H: 5-hmC Subset Proportion
Regional 5-hmC fraction was calculated at each timepoint and determined to be 5-hmC "high" or "low" based on a 0.10 cutoff. The proprotion of regions in each subset are shown for dynamic regions and static regions at each timepoint. Visualization code is shown [here](Figure5_scripts/fig5H_5hmCsubset.Rmd).
<ins>Input</ins><br>
.bed files for high and low 5-hmC regions <br>
.bed files for static and dynamic regions <br> 

### I: 5-hmC Subset Motif Enrichment
Motif enrichment was performed on regions that had "high" and "low" 5-hmC fractions at each timepoint. The relative motif enrichment (Fold Change) for select variable motifs across groups is shown. Visualization code is shown [here](Figure5_scripts/fig5H_5hmCsubset.Rmd).
<ins>Input</ins><br>
.bed files for high and low 5-hmC regions

### J: Footprint 5-hmC Signal
Footprinting was performed on peaks accessible at 4.5 days, as outlined in Figure 4A. The 5-hmC signal is shown at all motifs for the root cluster, seperated by whether they were called bound or unbound by TOBIAS. Visualization is done using deepTools, as outlined [here]()<br>
<ins>Input</ins><br>
.bed file for bound root cluster footprint regions<br>
.bed file for unbound root cluster footprint regions<br>
.bw for 5-hmC signal at each timepoint <br>

## Figure 6
