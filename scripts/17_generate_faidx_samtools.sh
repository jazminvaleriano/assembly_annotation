#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=faidx
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --partition=pibu_el8

# Working directory
WORKDIR=/data/users/jvaleriano/assembly_course
OUTDIR=$WORKDIR/Annotation_output/samtools
INPUT=$WORKDIR/assemblies/flye/flye_assembly.fasta

mkdir $OUTDIR

# Load module 
module load SAMtools/1.13-GCC-10.3.0

# Run samtools faidx 
samtools faidx $INPUT --fai-idx $OUTDIR/$(basename $INPUT).fai
