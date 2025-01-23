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
FLYE_ASM='/data/users/jvaleriano/assembly_course/assemblies/flye/flye_assembly.fasta'
HIFI_ASM='/data/users/jvaleriano/assembly_course/assemblies/hifiasm/hifiasm.fa'
LJA_ASM='/data/users/jvaleriano/assembly_course/assemblies/lja/lja_assembly.fasta'
TRANSCRIPTOME='/data/users/jvaleriano/assembly_course/assemblies/trinity.Trinity.fasta'

mkdir -p $OUTDIR
cd $OUTDIR

module load BUSCO/5.4.2-foss-2021a

# Run BUSCO for each genome assembly and the transcriptome

busco -i $FLYE_ASM --auto-lineage -o flye_busco -m genome --cpu 16 
busco -i $HIFI_ASM --auto-lineage -o hifiasm_busco -m genome --cpu 16 -f
busco -i $LJA_ASM --auto-lineage -o lja_busco -m genome --cpu 16 
busco -i $TRANSCRIPTOME --auto-lineage -o transc_busco -m transcriptome --cpu 16
