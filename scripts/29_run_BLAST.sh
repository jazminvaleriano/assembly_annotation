#!/bin/bash
#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --job-name=blast
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --mail-type=end

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/jvaleriano/assembly_course"
OUTDIR="$WORKDIR/Annotation_Evaluation/BLAST_output"

protein="$WORKDIR/Annotation_output/MAKER_out/final/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
gff="$WORKDIR/Annotation_output/MAKER_out/final/filtered.genes.renamed.final.gff3"

MAKERBIN="/data/courses/assembly-annotation-course/CDS_annotation/softwares/Maker_v3.01.03/src/bin/"
uniprot_fasta="/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa"

module load BLAST+/2.15.0-gompi-2021a
# makeblastb -in <uniprot_fasta> -dbtype prot # this step is already done

mkdir $OUTDIR

blastp -query $protein -db $uniprot_fasta -num_threads 10 -outfmt 6 -evalue 1e-10 -out blastp_output.txt
cp $protein $protein.Uniprot
cp $gff $gff.Uniprot

$MAKERBIN/maker_functional_fasta $uniprot_fasta blastp_output.txt $protein > $protein.Uniprot
$MAKERBIN/maker_functional_gff $uniprot_fasta blastp_output.txt $gff > $gff.Uniprot.gff3

mv blastp_output.txt $OUTDIR
mv $protein.Uniprot $OUTDIR
mv $gff.Uniprot.gff3 $OUTDIR