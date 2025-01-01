#!/bin/bash
#SBATCH --job-name=TEsorter        
#SBATCH --partition=pibu_el8              
#SBATCH --cpus-per-task=4              
#SBATCH --mem=8G                         
#SBATCH --time=01:00:00                
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID

WORKDIR=/data/users/jvaleriano/assembly_course
INPUT=/data/users/jvaleriano/assembly_course/Annotation_output/EDTA_output/flye_assembly.fasta.mod.EDTA.TElib.fa
OUTDIR=$WORKDIR/Annotation_output/TEsorterTE

mkdir $OUTDIR
cd $OUTDIR

module load SeqKit/2.6.1

# Classification for A. thaliana (my accession)
seqkit grep -r -p "Copia" $INPUT > Copia_arab_sequences.fa
seqkit grep -r -p "Gypsy" $INPUT > Gypsy_arab_sequences.fa

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Copia_arab_sequences.fa -db rexdb-plant

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Gypsy_arab_sequences.fa -db rexdb-plant

# Also run TEsorter on the Brassicaceae-specific TE library, 
# you will need Brassicaceae TEs for phylogenetic analysis

seqkit grep -r -p "Copia" /data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta > Copia_Brassicaceae_sequences.fa
seqkit grep -r -p "Gypsy" /data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta > Gypsy_Brassicaceae_sequences.fa

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Copia_Brassicaceae_sequences.fa -db rexdb-plant

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Gypsy_Brassicaceae_sequences.fa -db rexdb-plant

cd ../