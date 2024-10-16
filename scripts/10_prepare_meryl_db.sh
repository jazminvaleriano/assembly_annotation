#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=meryl_db
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Directories for the input and output files
OUT_DIR='/data/users/jvaleriano/assembly_course/asm_evaluation/merqury'
READS='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1/ERR11437327.fastq.gz'
mkdir -p $OUT_DIR

# Set the Merqury path variable 
export MERQURY="/usr/local/share/merqury"

# Prepare meryl Databases
apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
meryl count k=21 output $OUT_DIR/reads.meryl $READS
