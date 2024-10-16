#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity_asm
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Set the number of threads
THREADS=${SLURM_CPUS_PER_TASK}

# Directories for the input and output files
RNA_READS_DRI='/data/users/jvaleriano/assembly_course/read_QC/fastp'
OUTDIR='/data/users/jvaleriano/assembly_course/assemblies/trinity'

mkdir -p $OUTDIR

# Run Trinity from the module 
module load Trinity/2.15.1-foss-2021a

 Trinity --seqType fq --max_memory 64G --CPU $THREADS \
         --output $OUTDIR \
         --left $RNA_READS_DRI/rna_R1_trimmed.fastq  --right $RNA_READS_DRI/rna_R2_trimmed.fastq 
