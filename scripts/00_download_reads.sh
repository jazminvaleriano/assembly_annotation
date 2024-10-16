DATADIR='/data/courses/assembly-annotation-course/raw_data'
WORKDIR='/data/users/jvaleriano/assembly_course/'

cd $WORKDIR
mkdir ./reads

ln -s $DATADIR/Rubezhnoe-1 ./reads/
ln -s $DATADIR/RNAseq_Sha ./reads/