#!/bin/bash

# grab the files, and export it so the 'child' sbatch jobs can access it

# Directory where mapped sam file output from WALT is located
BAMDIR=/data/hodges_lab/NPCdiff_ATACme/data/mapped_reads
export FILES_rep1=($(ls -1 ${BAMDIR}/NPCdiffATACme*_rep1_filtered.bam))
export FILES_rep2=($(ls -1 ${BAMDIR}/NPCdiffATACme*_rep2_filtered.bam ))


# Output directory where primary output files of methpipe will go
export PROCESSED_DIR=/data/hodges_lab/NPCdiff_ATACme/data/peaks/Genrich
if test -d ${PROCESSED_DIR}; then  echo "exist"; else mkdir ${PROCESSED_DIR} && echo created; fi


# get size of array
NUMBAM=${#FILES_rep2[@]}
# now subtract 1 as we have to use zero-based indexing (first cell is 0)
ZBNUMBAM=$(($NUMBAM - 1))
for i in `seq 0 $ZBNUMBAM`;
do
echo ${FILES_rep1[$i]}
export BAM_rep1=${FILES_rep1[$i]}
echo ${FILES_rep2[$i]}
export BAM_rep2=${FILES_rep2[$i]}

# Run methpipe command via SLURM job scheduler
sbatch genrich.slrm
done
