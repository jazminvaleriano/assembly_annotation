#!/bin/bash
#SBATCH --time=7-00:00:00
#SBATCH --mem=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --job-name=Maker_gene_annotation
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/jvaleriano/assembly_course"
MAKERDIR="/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out"
CONTAINER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif"

cd $MAKERDIR

REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"

module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec \
 --bind $SCRATCH:/TMP --bind $COURSEDIR --bind $REPEATMASKER_DIR --bind $AUGUSTUS_CONFIG_PATH --bind $WORKDIR \
 $CONTAINER_DIR\
  maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl

# Merge the gff and fasta files
#$COURSEDIR/softwares/Maker_v3.01.03/src/bin/gff3_merge -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.gff
#$COURSEDIR/softwares/Maker_v3.01.03/src/bin/gff3_merge -n -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.noseq.gff
#$COURSEDIR/softwares/Maker_v3.01.03/src/bin/fasta_merge -d assembly.maker.output/assembly_master_datastore_index.log -o assembly

