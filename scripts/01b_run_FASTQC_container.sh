#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc_cont
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID


THREADS=${SLURM_CPUS_PER_TASK}

DNA_READS='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1'
RNA_READS='/data/users/jvaleriano/assembly_course/reads/RNAseq_Sha'
OUTDIR='/data/users/jvaleriano/assembly_course/read_QC/fastqc'

# Create the output directory if it doesn't exist
mkdir -p "$OUTDIR"

# Run FastQC using Apptainer
apptainer exec --no-home \
  --bind /data \
  /containers/apptainer/fastqc-0.12.1.sif \
  fastqc -t $THREADS $DNA_READS/*fastq.gz $RNA_READS/*fastq.gz -o $OUTDIR/


