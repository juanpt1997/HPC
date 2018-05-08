#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void escribirCSV(int fil, int col, float **m) 
{ 
	FILE *f = fopen("Matrices.csv", "a"); 
	for(int i=0; i<fil; i++){
		for(int j=0; j<col-1; j++){
			fprintf(f,"%f,", m[i][j]);
		}
		fprintf(f,"%f\n", m[i][col-1]); 
	}
	fprintf(f, "\n");
  	fclose(f); 
} 



float** MulMatrices(float **m1, float **m2, int fil, int col, int fil2){

	float** mr;
	mr = (float **)malloc (fil*sizeof(float *));
	for (int i=0; i<fil; i++)
		mr[i] = (float *) malloc (col*sizeof(float));

	for(int i=0; i<fil; i++){
    	for(int j=0; j<col; j++){
        	mr[i][j]=0;
        	for(int k=0; k<fil2; k++){
            	mr[i][j]+=m1[i][k]*m2[k][j];
        	}
    	}
	}	
	return mr;
}

void llenarMatrices(){

	int fil1, col1, fil2, col2;
	float** m1;
	float** m2;
	float** mr;


	/*while(1){
		printf("Ingrese el numero de filas de la matriz 1: ");
		scanf("%d",&fil1);
		printf("Ingrese el numero de columnas de la matriz 1: ");
		scanf("%d",&col1);

		printf("Ingrese el numero de filas de la matriz 2: ");
		scanf("%d",&fil2);
		printf("Ingrese el numero de columnas de la matriz 2: ");
		scanf("%d",&col2);

		if(col1 == fil2){
			break;
		}
		else{
			printf("Las matrices de estas dimensiones no se pueden multiplicar!\n\n");
		}
	}*/
	fil1 = 100;
	col1 = 200;
	fil2 = 200;
	col2 = 300;
	


	m1 = (float **)malloc (fil1*sizeof(float *));
	for (int i=0; i<fil1; i++)
		m1[i] = (float *) malloc (col1*sizeof(float));


	m2 = (float **)malloc (fil2*sizeof(float *));
	for (int i=0; i<fil2; i++){
		m2[i] = (float *) malloc (col2*sizeof(float));
	}



	srand(time(NULL));
	for(int i=0; i<fil1; i++){
		for(int j=0; j<col1; j++){
			m1[i][j] = rand(); 
		}
	}

	for(int i=0; i<fil2; i++){
		for(int j=0; j<col2; j++){
			m2[i][j] = rand(); 
		}
	}

	FILE *f = fopen("Matrices.csv", "w");
	fclose(f);

	//printf("matriz 1: ----------------------\n"); 

	escribirCSV(fil1, col1, m1);

	/*for(int i=0; i<fil1; i++){
		for(int j=0; j<col1; j++){
			printf("%f ", m1[i][j]);
		}
		printf("\n"); 
	}*/
	

	//printf("\nmatriz 2: ----------------------\n"); 

	escribirCSV(fil2, col2, m2);

	/*for(int i=0; i<fil2; i++){
		for(int j=0; j<col2; j++){
			printf("%f ", m2[i][j]);
		}
		printf("\n"); 
	}*/	


	//printf("\nmatriz 1 + matriz 2: ----------------------\n");*/

	mr = MulMatrices(m1, m2, fil1, col2, fil2);

	escribirCSV(fil1, col2, mr);

	/*for(int i=0; i<fil1; i++){
		for(int j=0; j<col2; j++){
			printf("%f ", mr[i][j]);
		}
		printf("\n"); 
	}*/
	free(m1);
	free(m2);
	free(mr);
}





int main()
{
	clock_t t_ini, t_fin;
  	double secs;

  	t_ini = clock();
  	llenarMatrices();
  	t_fin = clock();

  	secs = (double)(t_fin - t_ini) / CLOCKS_PER_SEC;
  	printf("Tiempo de ejecución: %.16g milisegundos\n", secs * 1000.0);
  	return 0;
}
