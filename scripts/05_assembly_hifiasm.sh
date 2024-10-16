#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifiasm
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Set the number of threads
THREADS=${SLURM_CPUS_PER_TASK}

# Directories for the input and output files
DNA_READS='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1'
OUTDIR='/data/users/jvaleriano/assembly_course/assemblies/hifiasm'

mkdir -p $OUTDIR

# Running hifiasm from the container
apptainer exec \
  --bind /data \
  /containers/apptainer/hifiasm_0.19.8.sif \
  hifiasm -o $OUTDIR/hifiasm -t $THREADS $DNA_READS/*.fastq.gz

# Convert gfa output to fasta
awk '/^S/{print ">"$2;print $3}' $OUTDIR/*p_utg.gfa > $OUTDIR/hifiasm.fa

