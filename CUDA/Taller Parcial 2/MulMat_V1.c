#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void EscribirMatriz(int fil, int col, float *m) { 
	FILE *f = fopen("outputSecuencial.txt", "a"); 
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


void LeerMatriz(float* m1, float* m2, FILE* file, int fil1, int fil2, int col1, int col2) {
	for(int i=0; i<fil1*col1; i++){
		fscanf(file, "%f", &m1[i]);
    }

	for(int i=0; i<fil2*col2; i++){
		fscanf(file, "%f", &m2[i]);
    }

	fclose(file);
}


void MulMatrices(float *m1, float *m2, float *mr, int fil1, int col1, int fil2, int col2){

	for(int i=0; i<fil1; i++){
		for(int j=0; j<col2; j++){
			int valor = 0;
			for(int k=0; k<fil2; k++){
				valor = valor + m1[(i*col1) + k]*m2[(k*col2) + j];

			}
			mr[(i*col2)+j] = valor;
		}
	}
}


int main(int argc, char** argv)
{
	if (argc != 2) {
    	printf("Parametros incorrectos! \n");
    	return 1;
	}

	clock_t t_ini, t_fin;
  	double secs;
  	t_ini = clock();

  	int fil1, col1, fil2, col2;
	float *m1, *m2, *mr;

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

	m1 = (float*)malloc(size1);
	m2 = (float*)malloc(size2);
	mr = (float*)malloc(sizer);

	LeerMatriz(m1, m2, archivo, fil1, fil2, col1, col2);
	MulMatrices(m1, m2, mr, fil1, col1, fil2, col2);

	EscribirMatriz(fil1, col1, m1);
	EscribirMatriz(fil2, col2, m2);
	EscribirMatriz(fil1, col2, mr);

	free(m1);
	free(m2);
	free(mr);

  	t_fin = clock();

  	secs = (double)(t_fin - t_ini) / CLOCKS_PER_SEC;
  	printf("Tiempo de ejecución: %.16g milisegundos\n", secs * 1000.0);
  	return 0;
}
