#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=QUAST_noref
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Directories for the input and output files
OUT_DIR='/data/users/jvaleriano/assembly_course/asm_evaluation/QUAST/no_ref'
GENOME_ASSEMBLIES='/data/users/jvaleriano/assembly_course/assemblies/flye/flye_assembly.fasta \
                   /data/users/jvaleriano/assembly_course/assemblies/hifiasm/hifiasm.fa \
                   /data/users/jvaleriano/assembly_course/assemblies/lja/lja_assembly.fasta'

mkdir -p $OUT_DIR

# Run QUAST for each genome assembly without a reference
apptainer exec --bind /data /containers/apptainer/quast_5.2.0.sif \
bash -c "
quast.py \
  $GENOME_ASSEMBLIES \
  -o $OUT_DIR \
  --threads 16 \
  --eukaryote \
  --large \
  --est-ref-size 135000000 \
  --labels flye,hifiasm,lja \
  --min-contig 3000 \
"
