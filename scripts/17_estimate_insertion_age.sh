#!/bin/bash
#SBATCH --job-name=TEage        
#SBATCH --partition=pibu_el8              
#SBATCH --cpus-per-task=4              
#SBATCH --mem=8G                         
#SBATCH --time=01:00:00                
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID

WORKDIR=/data/users/jvaleriano/assembly_course
INPUT=$WORKDIR/Annotation_output/EDTA_output/flye_assembly.fasta.mod.EDTA.anno/flye_assembly.fasta.mod.out
OUTDIR=$WORKDIR/Annotation_output/TE_age_estimation
SCRIPT=/data/users/jvaleriano/assembly_course/scripts/20_parseRM.pl

mkdir $OUTDIR

module add BioPerl/1.7.8-GCCcore-10.3.0
perl $SCRIPT -i $INPUT -l 50,1 -v

# Move the output files to the output directory.
mv $WORKDIR/Annotation_output/EDTA_output/flye_assembly.fasta.mod.EDTA.anno/*landscape* $OUTDIR/