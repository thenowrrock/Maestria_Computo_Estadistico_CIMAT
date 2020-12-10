#include <stdlib.h> // cout, cin
#include <iostream>
#include <pthread.h> // paralelizar
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <ctime> // time


using namespace std; //rand
#define HAVE_STRUCT_TIMESPEC
#define NTHREADS 4// numeros de hilos

struct  matriz {
    int m_filas;
    int m_columnas;
    long int **df;
};

typedef struct { // definimos la estructura
    int sup;
    int inf;
    matriz mat_1;
    matriz mat_2;
    matriz resultado;
} Argumentos;


int nA=2000; // inicializamos los tamaños de la matriz.
matriz A, B, C;

//----------------------------------Funciones generales---------------------------------------------
matriz iniciar_matriz(matriz mat){ // construimos la matriz utilizando la memoria dinamica.
    mat.df = new long int *[mat.m_filas];
    for(int i=0; i<mat.m_filas; i++){
        mat.df[i]=new long int[mat.m_columnas];
        }
    return mat;
}


void imprimir_matriz(matriz mat){           // imprimimos los elementos de la matriz.
    for (int i=0; i<mat.m_filas; i++){
        for (int j=0; j<mat.m_columnas; j++){
            cout << mat.df[i][j]<< " ";
        }
        cout << endl;
    }
}

matriz generar_matriz_aleatoria(matriz mat){   // asignamos valores aleatorias (0,99) a la matriz.
    mat = iniciar_matriz(mat);
    for (int i=0; i< mat.m_filas; i++){
        for (int j=0; j< mat.m_columnas; j++){
            mat.df[i][j]=rand()% 100;
        }
    }
    return mat;
}

//----------------------------------Operaciones matriciales---------------------------------------------
// Función suma.
void suma_matriz(matriz mat_1, matriz mat_2, matriz resultado, int inf, int sup){  // sumamos dos matrices.
    for (int i=0; i< resultado.m_filas; i++){
        for (int j = inf; j<sup; j++) {
            resultado.df[i][j] = mat_1.df[i][j]+mat_2.df[i][j];
        }
    }
}

void* suma_matriz_hilo(void *args) {
    Argumentos *_args = (Argumentos*) args;
    suma_matriz(_args->mat_1, _args->mat_2, _args->resultado, _args->inf, _args->sup);
    pthread_exit(NULL);
    return NULL;
}

void resta_matriz(matriz mat_1, matriz mat_2, matriz resultado, int inf, int sup){  // sumamos dos matrices.
    for (int i=0; i< resultado.m_filas; i++){
        for (int j = inf; j<sup; j++) {
            resultado.df[i][j] = mat_1.df[i][j]-mat_2.df[i][j];
        }
    }
}

void* resta_matriz_hilo(void *args) {
    Argumentos *_args = (Argumentos*) args;
    resta_matriz(_args->mat_1, _args->mat_2, _args->resultado, _args->inf, _args->sup);
    pthread_exit(NULL);
    return NULL;
}

void multiplicacion_matriz(matriz mat_1, matriz mat_2, matriz resultado, int inf, int sup){  // sumamos dos matrices.
    for(int row = inf; row < sup; ++row) {
        for(int col = 0; col <resultado.m_columnas; ++col) {
            long int sum = 0.0;
            for(int k = 0; k < resultado.m_columnas; ++k) {
                sum = sum + (mat_1.df[row][k] * mat_2.df[k][col]);
            }
        resultado.df[row][col] = sum;
        }
    }
}

void* multiplicacion_matriz_hilo(void *args) {
    Argumentos *_args = (Argumentos*) args;
    multiplicacion_matriz(_args->mat_1, _args->mat_2, _args->resultado, _args->inf, _args->sup);
    pthread_exit(NULL);
    return NULL;
}


void liberarmemoria(matriz mat){
for (int w = 0;  w< mat.m_filas; w++){
    delete [] mat.df[w] ;
    }
    delete [] mat.df ;
}


struct timespec begin, end;

int main(){
double elapsed;

A.m_columnas = nA;
A.m_filas = nA;
B.m_columnas = nA;
B.m_filas = nA;

C.m_columnas = nA;
C.m_filas = nA;
C = generar_matriz_aleatoria(C);


A = generar_matriz_aleatoria(A);
B = generar_matriz_aleatoria(B);

// imprimir_matriz(A);
cout << "B "  << endl;
// imprimir_matriz(B);

clock_gettime(CLOCK_MONOTONIC, &begin);

pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
Argumentos *args = new Argumentos[NTHREADS];
int subint = floor(nA/NTHREADS);  // limites para cada hilo

	for(int i=0; i<NTHREADS; i++){
		if(i==NTHREADS-1){       // limites para cada hilo
			args[i].sup = nA;
            args[i].inf = subint*i;
            args[i].mat_1 = A;
            args[i].mat_2 = B;
            args[i].resultado = C;
		} else{
			args[i].inf = subint*i;
			args[i].sup = subint*(i+1);
            args[i].mat_1 = A;
            args[i].mat_2 = B;
            args[i].resultado = C;
        }
        pthread_attr_t attr;     // asignamos las tareas a los hilos.
		pthread_attr_init(&attr);
		//pthread_create(&thr[i], &attr, suma_matriz_hilo, &args[i]);
        pthread_create(&thr[i], &attr, multiplicacion_matriz_hilo, &args[i]);

    }



    // medimos el tiempo de ejecución de la suma paralela
for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
    pthread_join(thr[i], NULL);
}
clock_gettime(CLOCK_MONOTONIC, &end);
elapsed = end.tv_sec - begin.tv_sec;
elapsed += (end.tv_nsec - begin.tv_nsec) / 1000000000.0;
cout << "Execution Time Paralela: " << elapsed << endl;
// imprimir_matriz(C);

// cout << "Suma" << endl;



clock_gettime(CLOCK_MONOTONIC, &begin);
// suma_matriz(A, B, C, 0, nA);
// multiplicacion_matriz(A, B, C, 0, nA);
clock_gettime(CLOCK_MONOTONIC, &end);
elapsed = end.tv_sec - begin.tv_sec;
elapsed += (end.tv_nsec - begin.tv_nsec) / 1000000000.0;
cout << "Execution Time Serie: " << elapsed << endl;
cout << "La suma secuencia genera es:" << endl; // imprimimos la elementos de la matriz.
// imprimir_matriz(C);


delete thr;  // limpiamos memoria.
delete args;
liberarmemoria( A);
liberarmemoria( B);
liberarmemoria( C);

cout << "-----------------------------------------------------------" << endl;
cout << "Saliendo del programa..." << endl;
return 0;
}


