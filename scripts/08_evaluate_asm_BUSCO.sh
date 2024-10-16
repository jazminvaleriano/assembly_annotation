#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=BUSCO
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Directories for the input and output files
OUTDIR='/data/users/jvaleriano/assembly_course/asm_evaluation/BUSCO'

mkdir -p $OUTDIR
cd $OUTDIR

# Run BUSCO for each genome assembly and the transcriptome
apptainer exec --bind /data /containers/apptainer/busco_5.7.1.sif \
bash -c '
  # Run BUSCO for flye assembly
  busco -i /data/users/jvaleriano/assembly_course/assemblies/flye/flye_assembly.fasta \
        --auto-lineage \
        -o flye_busco \
        -m genome \
        --cpu 16 \
        -f

  # Run BUSCO for hifiasm assembly
  busco -i /data/users/jvaleriano/assembly_course/assemblies/hifiasm/hifiasm.fa \
        --auto-lineage \
        -o hifiasm_busco \
        -m genome \
        --cpu 16 \
        -f

  # Run BUSCO for lja assembly
  busco -i /data/users/jvaleriano/assembly_course/assemblies/lja/lja_assembly.fasta \
        --auto-lineage \
        -o lja_busco \
        -m genome \
        --cpu 16

  # Run BUSCO for transcriptome assembly
  busco -i /data/users/jvaleriano/assembly_course/assemblies/trinity.Trinity.fasta \
        --auto-lineage \
        -o transcriptome_busco \
        -m transcriptome \
        --cpu 16
'
