.libPaths("/data/hodges_lab/R_3.6.0_VizPortal")

library("tidyverse")
library("pheatmap")
library("RColorBrewer")
library("cluster")
library("factoextra")
library("dendextend")

setwd('/data/hodges_lab/NPCdiff_ATACme/data/heatmaps/roi_R')

#read in dynamic clusters roi meth stat tsv for accessibility cluster IDs
acc_cluster_id <- read_tsv(file = "allTime_roiMeth.tsv") %>% mutate(id = paste0(chr,".",start,".",end)) %>% column_to_rownames(var = "id") %>% select(chr, start, end, acc_cluster = cluster)

#read in centered region average methylation for all peaks with greater than 0.1 methylation at all time points (i.e. with stably hypomethylated regions filtered out)
all_time_meth<- read_tsv(file = "allTime_allPeak_roiMeth.tsv")
all_time_meth <- all_time_meth %>% drop_na() %>% mutate(id= paste0(chr,".",start,".",end)) %>% column_to_rownames(var = "id")

allTime_roiMeth_0.1filt <- filter(all_time_meth, `0hr` <=  0.1 & `6hr` <= 0.1 & `12hr` <= 0.1 & `24hr` <=0.1 & `48hr` <= 0.1 & `72hr` <= 0.1 & `6day` <= 0.1 & `12day` <= 0.1)
allTime_roiMeth_g0.1filt <- anti_join(all_time_meth, allTime_roiMeth_0.1filt)
nrow(allTime_roiMeth_g0.1filt)

#merge in the accessibility cluster assignments, fill in nonassigned with static
all_time_meth_id <- left_join(allTime_roiMeth_g0.1filt, acc_cluster_id, by = c("chr", "start", "end"))
all_time_meth_id$acc_cluster <- all_time_meth_id$acc_cluster %>% replace_na("static")

all_matrix <- all_time_meth_id %>% select("0hr", "6hr", "12hr", "24hr", "48hr","72hr","108hr", "6day", "12day")

all_dist <- dist(all_matrix, method = "euclidean")

hclust_ward <-  hclust(all_dist, method = "ward.D2")

matrix_clust_ward <- cbind(all_time_meth_id, meth_cluster = stats::cutree(hclust_ward, k = 9))

write_tsv(matrix_clust_ward, file = "/data/hodges_lab/NPCdiff_ATACme/data/heatmaps/roi_R/peak0.1_withMeth_clusterids_ward9.tsv")
