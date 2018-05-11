#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda.h>
#define TILE_DIM 32

__global__ void MulMatriz(float *m1, float *m2, float *mr, int fil1, int col1,int fil2, int col2) {
	
	int i = blockIdx.y*TILE_DIM + threadIdx.y; // Row
	int j = blockIdx.x*TILE_DIM + threadIdx.x; // Col

	__shared__ float m1s[TILE_DIM][TILE_DIM];
	__shared__ float m2s[TILE_DIM][TILE_DIM];

	int valor = 0;
	
    int n = 0, m = 0;
    while(m < gridDim.x && n < gridDim.y){

		if(((m*TILE_DIM) + threadIdx.x)<col1 && i<fil1) {
			m1s[threadIdx.y][threadIdx.x] = m1[(i*col1) + ((m*TILE_DIM) + threadIdx.x)];
		}
		else {
			m1s[threadIdx.y][threadIdx.x] = 0;
		}
		
		if((n*TILE_DIM + threadIdx.y)<fil2 && j<col2) {
			m2s[threadIdx.y][threadIdx.x] = m2[((n*TILE_DIM + threadIdx.y)*col2) + j];
		}
		else {
			m2s[threadIdx.y][threadIdx.x] = 0;
		}
		m++; 
		n++;

		__syncthreads();

		for (int k=0; k < TILE_DIM ; k++) {
			valor += m1s[threadIdx.y][k]*m2s[k][threadIdx.x];
		}
		__syncthreads();
	}

	if(i<fil1 && j<col2) {
		mr[(i*col2) + j] = valor;
	}
}


__host__
void LeerMatriz(float* m1, float* m2, FILE* file, int fil1, int fil2, int col1, int col2) {
	for(int i=0; i<fil1*col1; i++){
		fscanf(file, "%f", &m1[i]);
    }

	for(int i=0; i<fil2*col2; i++){
		fscanf(file, "%f", &m2[i]);
    }

	fclose(file);
}

__host__
void EscribirMatriz(int fil, int col, float *m) { 
	FILE *f = fopen("outputSH.txt", "a"); 
	for(int i=0; i<fil; i++){
		for(int j=0; j<col; j++){
			if(j==col-1){
				fprintf(f,"%f\n", m[i*col+j]); 
			}
			else{
				fprintf(f,"%f,", m[i*col+j]);
			}
		}
	}
	fprintf(f, "\n");
  	fclose(f); 
} 


int main(int argc, char** argv) {
	if (argc != 2) {
    	printf("Parametros incorrectos! \n");
    	return 1;
	}

	clock_t t_ini, t_fin; //Inicia reloj ------------------------
	double secs;
	t_ini = clock();

	int fil1, col1, fil2, col2;
	float *h_m1, *h_m2, *h_mr;
	float *d_m1, *d_m2, *d_mr;

	FILE *archivo;
	archivo = fopen(argv[1], "r");
	fscanf(archivo, "%d %d", &fil1, &col1);
	fscanf(archivo, "%d %d", &fil2, &col2);

	if (col1 != fil2){
		printf("No se pueden multiplicar matrices de estas dimensiones!");
		return 1;
	}

	int size1 = fil1*col1*sizeof(float); //tamaño en bits de cada matriz
	int size2 = fil2*col2*sizeof(float);
	int sizer = fil1*col2*sizeof(float);

	h_m1 = (float*)malloc(size1);
	h_m2 = (float*)malloc(size2);
	h_mr = (float*)malloc(sizer);
	cudaMalloc(&d_m1, size1);
	cudaMalloc(&d_m2, size2);
	cudaMalloc(&d_mr, sizer);

	int blockSize = 32;
	dim3 dimBlock(blockSize, blockSize, 1);
	dim3 dimGrid(ceil(col1/float(blockSize)), ceil(col1/float(blockSize)), 1);

	LeerMatriz(h_m1, h_m2, archivo, fil1, fil2, col1, col2); 

	cudaMemcpy(d_m1, h_m1, size1, cudaMemcpyHostToDevice);
	cudaMemcpy(d_m2, h_m2, size2, cudaMemcpyHostToDevice);

	MulMatriz<<<dimGrid, dimBlock>>>(d_m1, d_m2, d_mr, fil1, col1, fil2, col2); //Ejecución del kernel
	cudaMemcpy(h_mr, d_mr, sizer, cudaMemcpyDeviceToHost); 

	EscribirMatriz(fil1, col1, h_m1);
	EscribirMatriz(fil2, col2, h_m2);
	EscribirMatriz(fil1, col2, h_mr);

	cudaFree(d_m1);
	cudaFree(d_m2);
	cudaFree(d_mr);
	free(h_m1);
	free(h_m2);
	free(h_mr);

  	t_fin = clock(); //Fin reloj ------------------------
  	secs = (double)(t_fin - t_ini) / CLOCKS_PER_SEC;
  	printf("Tiempo de ejecucion: %.16g milisegundos\n", secs * 1000.0);
  	
  	return 0;
}
