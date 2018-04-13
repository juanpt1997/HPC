#include <stdlib.h>
#include <stdio.h>
#include <cuda.h>


__host__
void read(float *M, FILE *source, int rows, int cols){
	for (int i = 0; i < rows; ++i){
		for (int j = 0; j < cols; ++j){
			fscanf(source, "%f,", &M[i * cols + j]);
		}
	}
	fclose(source);
	return;
}

__host__
void print(float *M, int rows, int cols){
  printf("\n");
  printf("----------------------------------------\n");
  for(int i = 0; i < rows; i++) {
  		for(int j = 0; j < cols; j++) {
     		printf("%.2f ", M[i * cols + j]);
    	}
		printf("\n");
  }
  printf("----------------------------------------\n");
  printf("\n");
  return;
}

__global__
void MatrixMultiplyKernel(float *d_A, float *d_B, float *d_R, int colsA, int rowsA, int colsB, int rowsB){

	int col = threadIdx.x + blockDim.x * blockIdx.x;
	int row = threadIdx.y + blockDim.y * blockIdx.y;

	if((row < rowsA) && (col < colsB)){
		float cont = 0.0;
		for (int k = 0; k < rowsB; ++k){
			cont += d_A[row * colsA + k] * d_B[k * colsB + col];
		}
		d_R[row * colsB + col] = cont;
	}
	return;
}


int main(int argc, char** argv)
{

	if (argc != 3){
		printf("Debe añadir los nombres de los archivos\n");
		return 1;
	}

	float *h_A, *h_B, *h_R;
	int rowsA, rowsB, colsA, colsB;


	cudaError_t error = cudaSuccess;

	FILE *file_1, *file_2;
	file_1 = fopen(argv[1], "r");
	file_2 = fopen(argv[2], "r");

	fscanf(file_1, "%d", &rowsA);
	fscanf(file_1, "%d", &colsA);
	fscanf(file_2, "%d", &rowsB);
	fscanf(file_2, "%d", &colsB);

	if (colsA != rowsB){
		printf("Es imposible multiplicar las matrices\n");
		return 1;
	}

	float sizeA = rowsA * colsA * sizeof(float);
	float sizeB = rowsB * colsB * sizeof(float);
	float sizeR = rowsA * colsB * sizeof(float);


	h_A = (float*)malloc(sizeA);
	h_B = (float*)malloc(sizeB);
	h_R = (float*)malloc(sizeR);

	read(h_A, file_1, rowsA, colsA);
	read(h_B, file_2, rowsB, colsB);

	float *d_A, *d_B, *d_R;

	error = cudaMalloc((void**)&d_A, sizeA);
	if (error != cudaSuccess){
		printf("Error solicitando memoria para d_A \n");
		return 1;
	}

	error = cudaMalloc((void**)&d_B, sizeB);
	if (error != cudaSuccess){
		printf("Error solicitando memoria para d_B \n");
		return 1;
	}

	error = cudaMalloc((void**)&d_R, sizeR);
	if (error != cudaSuccess){
		printf("Error solicitando memoria para d_R \n");
		return 1;
	}

	cudaMemcpy(d_A, h_A, sizeA, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, sizeB, cudaMemcpyHostToDevice);

	int blockSize = 32;
	dim3 dimGrid(ceil((colsB) / float(blockSize)), ceil((rowsA)/ float(blockSize)), 1);
	dim3 dimBlock(blockSize, blockSize, 1);

	MatrixMultiplyKernel<<<dimGrid, dimBlock>>>(d_A, d_B, d_R, colsA, rowsA, colsB, rowsB);
	cudaMemcpy(h_R, d_R, sizeR, cudaMemcpyDeviceToHost);

	print(h_A, rowsA, colsA);
	print(h_B, rowsB, colsB);
	print(h_R, rowsA, colsB);


	free(h_A);
	free(h_B);
	free(h_R);
	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_R);


	/* code */
	return 0;
}