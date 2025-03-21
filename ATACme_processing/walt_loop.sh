#!/bin/bash

# Line 1 of this file must not be altered as it indicates how the command line interpreter should handle this script
# grab the files, and export it so the 'child' sbatch jobs can access it

# Directory where trimmed fastq files are located
# These files should not be gzipped
FQDIR=/data/hodges_lab/NPCdiff_ATACme/data/trimmed_reads/new_timepoints

# Export read1 and read2
export FILESR1=($(ls -1 ${FQDIR}/*_val_1.fq))
export FILESR2=($(ls -1 ${FQDIR}/*_val_2.fq))

# Directory that contains the WALT mapping index
# Index must be built via WALT
# Directory line should end in the prefix that designates all the .dbindex files
export INDEX=/data/hodges_lab/hg38_genome/hg38.dbindex

# Directory where the mapped files will be output
export MAPPED_DIR=/data/hodges_lab/NPCdiff_ATACme/data/mapped_reads/new_timepoints

# Test if the mapped directory has been created, if not then make the directory
if test -d ${MAPPED_DIR}; then  echo "exist"; else mkdir ${MAPPED_DIR} && echo created; fi

# get size of array
NUMFASTQ=${#FILESR2[@]}
# now subtract 1 as we have to use zero-based indexing (first cell is 0)
ZBNUMFASTQ=$(($NUMFASTQ - 1))
for i in `seq 0 $ZBNUMFASTQ`;
do
echo ${FILESR1[$i]}
export R1=${FILESR1[$i]}
export R2=${FILESR2[$i]}

# Run sbatch which will initiate the SLURM scheduler jobs
# The SLURM job contains the WALT mapping command
sbatch walt.slrm
done
