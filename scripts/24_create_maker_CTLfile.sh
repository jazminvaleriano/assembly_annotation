#!/usr/bin/env bash

#SBATCH --cpus-per-task=20
#SBATCH --mem=40G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=maker_preparation
#SBATCH --partition=pibu_el8
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID

OUTDIR=/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out
CONTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif"

mkdir -p $OUTDIR
cd $OUTDIR

#Create control files
apptainer exec --bind /data \
$CONTAINER maker -CTL

 

