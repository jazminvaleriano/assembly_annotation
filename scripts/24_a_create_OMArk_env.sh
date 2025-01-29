# This script was run on an interactive session

# To start the interactive session:
srun --time=02:00:00 --mem=4G --ntasks=1 --cpus-per-task=1 --partition=pibu_el8 --pty bash

# Load conda module
module load Anaconda3/2022.05
# Initialize conda
eval "$(conda shell.bash hook)"
# Create environment
conda env create -f /data/courses/assembly-annotation-course/CDS_annotation/containers/OMArk.yaml
conda activate OMArk
pip install omadb
pip install gffutils

# To activate (at the beginning of the next script):
# conda activate OMArk