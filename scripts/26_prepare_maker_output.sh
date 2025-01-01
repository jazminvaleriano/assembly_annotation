#!/bin/bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=40G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --job-name=Maker_prep
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

DS_INDEX="$WORKDIR/flye_assembly.maker.output/flye_assembly_master_datastore_index.log"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

gff="assembly.all.maker.noseq.gff"
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
prefix="Rubezhnoe-1"

module load UCSC-Utils/448-foss-2021a
module load BioPerl/1.7.8-GCCcore-10.3.0
module load MariaDB/10.6.4-GCC-10.3.0

cd $WORKDIR

## Merge the individual GFF files
#$MAKERBIN/gff3_merge -s -d $DS_INDEX > assembly.all.maker.gff
#$MAKERBIN/gff3_merge -n -s -d $DS_INDEX > assembly.all.maker.noseq.gff
#$MAKERBIN/fasta_merge -d $DS_INDEX -o assembly

## Create a directory to store the final files after filtering them based on AED values and InterProScan annotations
#mkdir final
#cp $gff final/${gff}.renamed.gff
#cp $protein final/${protein}.renamed.fasta
#cp $transcript final/${transcript}.renamed.fasta

cd final

## Give clean gene names, update the gff and fasta files
#$MAKERBIN/maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > id.map
#$MAKERBIN/map_gff_ids id.map ${gff}.renamed.gff
#$MAKERBIN/map_fasta_ids id.map ${protein}.renamed.fasta
#$MAKERBIN/map_fasta_ids id.map ${transcript}.renamed.fasta

## Run InterProScan to annotate protein sequences with functional domains
#apptainer exec \
#    --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
#    --bind $WORKDIR \
#    --bind $COURSEDIR \
#    --bind $SCRATCH:/temp \
#    $COURSEDIR/containers/interproscan_latest.sif \
#    /opt/interproscan/interproscan.sh \
#    -appl pfam --disable-precalc -f TSV \
#    --goterms --iprlookup --seqtype p \
#    -i ${protein}.renamed.fasta -o output.iprscan

# here we are using interproscan on only pfam analysis, you can use other analysis as well
# example: -appl CDD,COILS,Gene3D,HAMAP,MobiDBLite,PANTHER,Pfam,PIRSF,PRINTS,PROSITEPATTERNS,PROSITEPROFILES,SFLD,SMART,SUPERFAMILY,TIGRFAM 
# a list of all analyses can be found here: https://interproscan-docs.readthedocs.io/en/latest/HowToRun.html#included-analyses

#######################
# 13574674 HASTA AQUÍ

# Update the gff file with InterProScan results and filter it for quality
$MAKERBIN/ipr_update_gff ${gff}.renamed.gff output.iprscan > ${gff}.renamed.iprscan.gff

# Get the AED values for the genes
perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 ${gff}.renamed.gff > assembly.all.maker.renamed.gff.AED.txt

# plot the AED values. 
# Question: Are most of your genes in the range 0-0.5 AED?

# Filter the gff file based on AED values and Pfam domains
perl $MAKERBIN/quality_filter.pl -s ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff
# In the above command: -s  Prints transcripts with an AED <1 and/or Pfam domain if in gff3 
## Note: When you do QC of your gene models, you will see that AED <1 is not sufficient. We should rather have a script with AED <0.5

# The gff also contains other features like Repeats, and match hints from different sources of evidence
# Let's see what are the different types of features in the gff file
cut -f3 ${gff}_iprscan_quality_filtered.gff | sort | uniq

# We only want to keep gene features in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# We need to add back the gff3 header to the filtered gff file so that it can be used by other tools
grep "^#" ${gff}_iprscan_quality_filtered.gff > header.txt
cat header.txt filtered.genes.renamed.gff3 > filtered.genes.renamed.final.gff3

# Get the names of remaining mRNAs and extract them from the transcript and and their proteins from the protein files
grep -P "\tmRNA\t" filtered.genes.renamed.final.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' >mRNA_list.txt
faSomeRecords ${transcript}.renamed.fasta mRNA_list.txt ${transcript}.renamed.filtered.fasta
faSomeRecords ${protein}.renamed.fasta mRNA_list.txt ${protein}.renamed.filtered.fasta



