module restore tools

for i in 1 2 3 4 5 6 7

do

bedtools intersect -u -a h1embryonicstsemcellENCODEhg38.bed -b {DIR}/peak_subset_cluster_${i}.bed > ${OUTPUT_DIR}/cluster${i}_ESCchromHMMhg38.bed 

bedtools intersect -u -a h9neuralstemcellENCODEhg38.bed -b {DIR}/peak_subset_cluster_${i}.bed > ${OUTPUT_DIR}/cluster${i}_NPCchromHMMhg38.bed 

done

bedtools intersect -u -a h1embryonicstsemcellENCODEhg38.bed -b {DIR}/peak_subset_static.bed > ${OUTPUT_DIR}/static_ESCchromHMMhg38.bed

bedtools intersect -u -a h9neuralstemcellENCODEhg38.bed -b {DIR}/peak_subset_cluster_${i}.bed > ${OUTPUT_DIR}/static_NPCchromHMMhg38.bed 
