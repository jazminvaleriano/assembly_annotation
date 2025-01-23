#!/usr/bin/env bash

#SBATCH --time=24:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=EDTA_annotation
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jvaleriano/assembly_course/EDTA_output"
mkdir $WORKDIR
cd $WORKDIR

ASSEMBLY="/data/users/jvaleriano/assembly_course/assemblies/flye/flye_assembly.fasta"
CDS="/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated"

apptainer exec -C --bind /data -H ${pwd}:/work \
    --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/EDTA_v1.9.6.sif EDTA.pl \
    --genome $ASSEMBLY \
    --species others \
    --step all \
    --cds $CDS \
    --anno 1 \
    --threads 20
