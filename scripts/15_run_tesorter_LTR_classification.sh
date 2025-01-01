#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=tesorter
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/jvaleriano/assembly_course
OUTDIR=$WORKDIR/Annotation_output/TEsorterLTR
CONTAINER=/data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif
INPUT=$WORKDIR/EDTA_output/flye_assembly.fasta.mod.EDTA.raw/LTR/flye_assembly.fasta.mod.LTR.intact.fa

# Go to working directory and create output directory
mkdir -p $OUTDIR
pushd $WORKDIR

apptainer exec -C -H $WORKDIR \
  --writable-tmpfs -u $CONTAINER \
  TEsorter $INPUT -db rexdb-plant -nocln

mv flye_assembly.fasta.mod.LTR.intact.fa.rexdb-plant.* $OUTDIR
rm -r tmp

popd