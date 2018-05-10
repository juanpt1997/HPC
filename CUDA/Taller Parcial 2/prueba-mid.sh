#!/bin/bash

#SBATCH --job-name=MatrixMul
#SBATCH --output=MatrixMul-Mid.out
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --gres=gpu:1

export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

export CUDA_VISIBLE_DEVICES=0

./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
rm outputSecuencial.txt
./out1 input-mid.txt
echo
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
rm outputIngenuo.txt
./out2 input-mid.txt
echo
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
rm outputSH.txt
./out3 input-mid.txt
