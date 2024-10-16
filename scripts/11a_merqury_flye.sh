#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=merqury_flye
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID

# Directories for the input and output files
OUTDIR='/data/users/jvaleriano/assembly_course/asm_evaluation/merqury/flye'
ASSEMBLY='/data/users/jvaleriano/assembly_course/assemblies/flye/flye_assembly.fasta'
MERYL_DB='/data/users/jvaleriano/assembly_course/asm_evaluation/merqury/reads.meryl'

# Create output directory and temporarily switch to it
mkdir -p $OUTDIR
pushd $OUTDIR

# Set the Merqury path variable 
export MERQURY="/usr/local/share/merqury"

# Run Merqury with the pre-prepared meryl database and the Flye assembly
apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
merqury.sh $MERYL_DB $ASSEMBLY merq

# Switch back to the original directory
popd
