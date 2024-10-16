#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Set the number of threads
THREADS=${SLURM_CPUS_PER_TASK}

# Directories for the input and output files
WORKDIR='/data/users/jvaleriano/assembly_course'
DNA_READS='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1'
OUTDIR='/data/users/jvaleriano/assembly_course/assemblies/flye'

mkdir -p $OUTDIR

# Run flye using Apptainer 
apptainer exec \
  --bind /data \
  /containers/apptainer/flye_2.9.5.sif \
  flye --out-dir $OUTDIR --threads $THREADS --pacbio-hifi $DNA_READS/*fastq.gz

#module load Flye/2.9-GCC-10.3.0
#flye --pacbio-hifi ${DNA_READS}/*fastq.gz --out-dir $OUTDIR --threads $THREADS
