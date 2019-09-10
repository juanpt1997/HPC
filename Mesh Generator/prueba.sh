#!/bin/bash

#SBATCH --job-name=Distmesh2D
#SBATCH --output=Distmesh.out
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --mem=1024

export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64\
                         ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia-390


export CUDA_VISIBLE_DEVICES=0

python Main.py
python Main.py
python Main.py
python Main.py
python Main.py
echo
python MainCUDA.py
python MainCUDA.py
python MainCUDA.py
python MainCUDA.py
python MainCUDA.py