#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=LJA_assembly
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Set the number of threads
THREADS=${SLURM_CPUS_PER_TASK}

# Directories for the input and output files
DNA_READS='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1'
OUTDIR='/data/users/jvaleriano/assembly_course/assemblies/lja'

mkdir -p $OUTDIR

# Run LJA assembler from the container
apptainer exec \
  --bind /data \
  /containers/apptainer/lja-0.2.sif \
  lja -t $THREADS --diploid -o $OUTDIR --reads $DNA_READS/*.fastq.gz


