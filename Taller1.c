#include <stdlib.h>
#include <stdio.h>
#include <time.h>

//-----------------------------------------------------------
//----------------------VECTOR-------------------------------
//-----------------------------------------------------------

void FillVector(float *vector, int size){


	for (int i = 0; i < size; ++i)
	{
		//vector[i] = rand();
		vector[i] = rand()%50;
	}
}

void PrintVector(float *vector, int size){


	for (int i = 0; i < size; ++i)
	{
		printf("%.2f\n", vector[i]);
	}
}

void SumVector(float *vector, float *vector2, float *sumV, int size){
	for (int i = 0; i < size; ++i)
	{
		sumV[i] = vector[i] + vector2[i];
	}

}

void saveVector(float *Vector, int size){
  FILE *f = fopen("Sum_Vector.csv", "a");

  if (f == NULL){
    printf("File error\n");
    exit(-1);
  }

  for (int i = 0; i < size; i++) {
    if(size - 1 == i){
      fprintf(f, "%.2f", Vector[i]);
    }
    else{
      fprintf(f, "%.2f, ", Vector[i]);
    }
  }
  fprintf(f, "\n");
  fclose(f);
}

void Vector(){
	float *vector;
	float *vector2;
	int size;

	printf("Ingrese tamaño vector: ");
	scanf("%d", &size);

	vector = (float *)malloc(size*sizeof(float));
	vector2 = (float *)malloc(size*sizeof(float));

	srand(time(NULL));
	FillVector(vector, size);
	FillVector(vector2, size);

	printf("\nVector 1: \n");
	PrintVector(vector, size);
	printf("\nVector 2: \n");
	PrintVector(vector2, size);


	float *sumV;
	sumV = (float *)malloc(size*sizeof(float));
	SumVector(vector, vector2, sumV, size);

	printf("\n\nSuma vectores: \n");
	PrintVector(sumV, size);

	saveVector(vector, size);
	saveVector(vector2, size);
	saveVector(sumV, size);
}

//-------------------------------------------------------------
//------------------------MATRIX-------------------------------
//-------------------------------------------------------------
void FillMatrix(float **matrix, int n, int m){


	for (int i = 0; i < n; ++i)
	{
		for (int j = 0; j < m; ++j)
		{
			matrix[i][j] = rand()%50;
		}
	}
}


void PrintMatrix(float **matrix, int n, int m){


	for (int i = 0; i < n; ++i)
	{
		for (int j = 0; j < m; ++j)
		{
			printf("%.2f\t", matrix[i][j]);
		}
		printf("\n");
	}
}


void MultMat(float **matrix, int n1, int m1, float **matrix2, int n2, int m2, float **multM){
	float suma;
	for (int i = 0; i < n2; ++i){
            for (int j = 0; j < m1; ++j){
                suma = 0.0;
                for (int k = 0; k < n1; ++k){
                        suma = suma + (matrix[k][j] * matrix2[i][k]);

                }
                multM[i][j] = suma;
            }

        }
}

void saveMatrix(float **Matrix, int row, int col){
  FILE *f = fopen("Mult_Matrix.csv", "a");

  if (f == NULL){
    printf("File error\n");
    exit(-1);
  }

  for (int i = 0; i < row; i++) {
    for (int j = 0; j < col; ++j){
      if(col - 1 == j){
        fprintf(f, "%.2f", Matrix[i][j]);
      }
      else{
        fprintf(f, "%.2f, ",  Matrix[i][j]);
      }
    }
     fprintf(f, "\n");
  }

  fprintf(f, "\n");
  fclose(f);

  return;
}

void Matrix(){
	//Matriz 1
	float **matrix;
	int n1; //Filas
	int m1; //Columnas

	printf("Ingrese numero de filas de la matriz 1: ");
	scanf("%d", &n1);

	printf("Ingrese numero de columnas de la matriz 1: ");
	scanf("%d", &m1);

	matrix = (float **)malloc(n1*sizeof(float*));
	for (int i = 0; i < n1; ++i)
	{
		matrix[i] = (float *)malloc(m1*sizeof(float));
	}


	//Matriz 2
	float **matrix2;
	int n2; //Filas
	int m2; //Columnas

	printf("\nIngrese numero de filas de la matriz 2: ");
	scanf("%d", &n2);

	printf("Ingrese numero de columnas de la matriz 2: ");
	scanf("%d", &m2);

	matrix2 = (float **)malloc(n2*sizeof(float*));
	for (int i = 0; i < n2; ++i)
	{
		matrix2[i] = (float *)malloc(m2*sizeof(float));
	}



	srand(time(NULL));
	FillMatrix(matrix, n1, m1);
	FillMatrix(matrix2, n2, m2);


	printf("\nMatrix 1: \n");
	PrintMatrix(matrix, n1, m1);
	printf("\nMatrix 2: \n");
	PrintMatrix(matrix2, n2, m2);


	//Mult Matrix
    float **multM;
	if (n1 == m2){
	    multM = (float **)malloc(n2*sizeof(float*));
        for (int i = 0; i < n2; ++i)
        {
            multM[i] = (float *)malloc(m1*sizeof(float));
        }

		MultMat(matrix, n1, m1, matrix2, n2, m2, multM);
		printf("\n\nMultiplicacion matrices: \n");
        PrintMatrix(multM, n2, m1);
        saveMatrix(matrix, n1, m1);
        saveMatrix(matrix2, n2, m2);
        saveMatrix(multM, n2, m1);

	}
	else{
		printf("Error, no es posible multiplicar debido a que el numero de filas de la matriz 1 es diferente al numero de columnas de la matriz 2");
	}
}




int main(int argc, char const *argv[])
{
    int op;

    do{
        printf("\n\n\tTALLER 1\n\n");
        printf("1. Suma de dos vectores: \n");
        printf("2. Multiplicacion de dos matrices: \n");
        printf("\nDigite una opcion: ");
        scanf("%d", &op);

        switch(op){

            case 1: Vector();
                    break;

            case 2: Matrix();
                    break;

            default:
                break;
            }
    }while(op != 0);

	return 0;
}
