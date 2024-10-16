#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc_mod
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

THREADS=${SLURM_CPUS_PER_TASK}
WORKDIR='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1'
OUTDIR='/data/users/jvaleriano/assembly_course/read_QC/fastqc'

# Create the output directory if it doesn't exist
echo "Creating output directory at $OUTDIR"
mkdir -p "$OUTDIR"

# Load FASTQC
module load FastQC/0.11.9-Java-11

# Run FastQC
fastqc -t $THREADS $WORKDIR/*fastq.gz -o $OUTDIR/