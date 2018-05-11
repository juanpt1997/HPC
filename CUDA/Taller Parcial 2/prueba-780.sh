#!/bin/bash

#SBATCH --job-name=MatrixMul
#SBATCH --output=MatrixMul-780-short.out
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --mem=1024

export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

export CUDA_VISIBLE_DEVICES=1

./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
./out1 input-short.txt
rm outputSecuencial.txt
echo
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
./out2 input-short.txt
rm outputIngenuo.txt
echo
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
./out3 input-short.txt
rm outputSH.txt
