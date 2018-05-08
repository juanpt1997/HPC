#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda.h>

__global__ void MulMatriz(float *min, float *mout, int fil, int col)
{
	int i = blockIdx.y * blockDim.y + threadIdx.y;
    int j = blockIdx.x * blockDim.x + threadIdx.x;

    if ((i < fil) && (j < col)){
        mout[i*col+j] = 2*min[i*col+j]; 
    }
}


int main()
{
	//Inicia reloj ------------------------
	clock_t t_ini, t_fin;
  	double secs;
  	t_ini = clock();
  	//-------------------------------------

	int fil, col;
	float *h_min, *h_mout;
	float *d_min, *d_mout;

	fil = 5;
	col = 6; //con el más grande se hace la referencia para la matriz en 1D

	int size = fil*col*sizeof(float); //tamaño en bits de cada matriz

	h_min = (float*)malloc(size);
	h_mout = (float*)malloc(size);
	cudaMalloc(&d_min, size);
    cudaMalloc(&d_mout, size);

    int blockSize = 32;
    dim3 dimBlock(blockSize, blockSize, 1);
    dim3 dimGrid(ceil(col/float(blockSize)), ceil(col/float(blockSize)), 1);

	//Iniciar matriz con valor 13------------------
	for(int i=0; i<fil; i++){
		for(int j=0; j<col; j++){
			h_min[i*col+j] = 13; 
		}
	}

	//Imprimir resultados------------------
	printf("matriz: ----------------------\n"); 
	for(int i=0; i<fil; i++){
		for(int j=0; j<col; j++){
			printf("%f ", h_min[i*col+j]);
		}
		printf("\n"); 
	}	

	printf("\nmatriz x5: ----------------------\n"); 

	cudaMemcpy(d_min, h_min, size, cudaMemcpyHostToDevice);
	MulMatriz<<<dimGrid, dimBlock>>>(d_min, d_mout, fil, col); //Ejecución del kernel
	cudaMemcpy(h_mout, d_mout, size, cudaMemcpyDeviceToHost); //Copia de datos al host
	
	//Imprimir resultados------------------
	for(int i=0; i<fil; i++){
		for(int j=0; j<col; j++){
			printf("%f ", h_mout[i*col+j]);
		}
		printf("\n"); 
	}
	//-------------------------------------

	cudaFree(d_min);
    cudaFree(d_mout);
	free(h_min);
	free(h_mout);

	//Fin reloj ------------------------
  	t_fin = clock();
  	secs = (double)(t_fin - t_ini) / CLOCKS_PER_SEC;
  	printf("Tiempo de ejecucion: %.16g milisegundos\n", secs * 1000.0);
  	
  	return 0;
}
