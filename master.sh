#!/bin/bash

## slurm options
#SBATCH --mail-user = amina.echchiki@unil.ch
#SBATCH --mail-type = ALL
#SBATCH --job-name = master_test
#SBATCH --partition = normal

## modules load
module add Bioinformatics/Software/vital-it
module add UHTS/Analysis/samtools/1.8
module add UHTS/Assembler/cufflinks/2.2.1

## check or create directory tree
mkdir -p A_input B_analysis C_output D_tmp
mkdir -p A_input/raw A_input/ref A_input/wrk

## change execution params (at root)
chmod +x -R .

