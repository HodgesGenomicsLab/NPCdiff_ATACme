library(tidyverse)
library("factoextra") 
library("farver")
install.versions('scales', '0.5.0')
library("scales")

set.seed(123)

setwd('/data/hodges_lab/NPCdiff_ATACme/data/TC_seq')
NPC_t <- read_tsv("/data/hodges_lab/NPCdiff_ATACme/data/TC_seq/TCseq_NPCdiff_ATAC_ExpressionTable.txt", 
	col_names = c("peakID", "0hr", "6hr", "12hr", "24hr", "48hr","72hr","108hr", "6day", "12day"), skip = 1) %>% 
	column_to_rownames(var = "peakID")
	
elbow <- fviz_nbclust(NPC_t, kmeans, method = "wss")


sil <- fviz_nbclust(NPC_t, kmeans, method = "silhouette")


library(cluster)

# Compute gap statistic for kmeans
# we used B = 10 for demo. Recommended value is ~500
gap_stat <- clusGap(iris.scaled, FUN = kmeans, nstart = 5,
 K.max = 20, B = 500)
 print(gap_stat, method = "firstmax")
 
gap<- fviz_gap_stat(gap_stat)

ggsave(elbow, filename = "/data/hodges_lab/NPCdiff_ATACme/data/TC_seq/elbow_cluster.pdf", unit= "in", width = 8, height = 6, device = cairo_pdf)
ggsave(sil, filename = "/data/hodges_lab/NPCdiff_ATACme/data/TC_seq/silhouette_cluster.pdf", unit= "in", width = 8, height = 6, device = cairo_pdf)
ggsave(gap, filename = "/data/hodges_lab/NPCdiff_ATACme/data/TC_seq/gap_cluster.pdf", unit= "in", width = 8, height = 6, device = cairo_pdf)
