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
    float **df;
};



//----------------------------------Funciones generales---------------------------------------------

void imprimir_matriz(matriz A){           // imprimimos los elementos de la matriz.
    for (int i=0; i<A.m_filas; i++){
        for (int j=0; j<A.m_columnas; j++){
            cout << A.df[i][j]<< " ";
        }
        cout << endl;
    }
}

matriz generar_matriz_aleatoria(matriz A){   // asignamos valores aleatorias (0,99) a la matriz.
    for (int i=0; i<A.m_filas; i++){
        for (int j=0; j<A.m_columnas; j++){
            A.df[i][j]=rand()% 100;
        }
    }
    cout << "La matriz genera es:" << endl; // imprimimos la elementos de la matriz.

    return A;
}

//----------------------------------Operaciones matriciales---------------------------------------------
// Función suma.
matriz suma_matriz(matriz A, matriz B, int inf, int sup){  // sumamos dos matrices.
    for (int i=0; i<= A.m_filas-1; i++){
        for (int j = inf; j<sup; j++) {
            A.df[i][j]=A.df[i][j]+B.df[i][j];
        }
    }
}

void liberarmemoria(matriz A){
for (int w = 0;  w< A.m_filas; w++){
    delete [] A.df[w] ;
    }
    delete [] A.df ;
}


int nA=10000; // inicializamos los tamaños de la matriz.
matriz A, B, C;

typedef struct { // definimos la estructura
	int sup;
	int inf;
    matriz A;
    matriz B;
} Argumentos;


void* product_worker(void *args) {
	Argumentos *_args = (Argumentos*) args;
	suma_matriz(_args->A, _args->B, _args->inf, _args->sup);
    pthread_exit(NULL);
	return NULL;
}


int main(){
unsigned t0, t1; // variables de tiempo

A.m_columnas = nA;
A.m_filas = nA;
B.m_columnas = nA;
B.m_filas = nA;

A = generar_matriz_aleatoria(A);
B = generar_matriz_aleatoria(B);

pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
Argumentos *args; // inicializamos las estructura para los hilos
args = (Argumentos *)malloc(sizeof(Argumentos)*NTHREADS);

int subint = floor(nA/NTHREADS);  // limites para cada hilo

	for(int i=0; i<NTHREADS; i++){
		if(i==NTHREADS-1){       // limites para cada hilo
			args[i].sup = nA;
            args[i].inf = subint*i+1;
		}else{
			args[i].inf = subint*i;
			args[i].sup = subint*(i+1);
		}
        pthread_attr_t attr;     // asignamos las tareas a los hilos.
		pthread_attr_init(&attr);
		pthread_create(&thr[i], &attr, product_worker, (void *)(args + i));
    }

t0=clock();         // medimos el tiempo de ejecución de la suma paralela
for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
    pthread_join(thr[i], NULL);
}
t1 = clock();    // imprimimos el tiempo.
double time = (double(t1-t0)/CLOCKS_PER_SEC); // imprimimos el tiempo.
cout << "Execution Time Paralela: " << time << endl;


cout << "La suma paralela genera es:" << endl; // imprimimos la elementos de la matriz.
//A->print();




cout << "La suma serie genera es:" << endl; // imprimimos la elementos de la matriz.
t0=clock();
suma_matriz(A, B, 0, nA);
t1 = clock();    // imprimimos el tiempo.
time = (double(t1-t0)/CLOCKS_PER_SEC); // imprimimos el tiempo.
cout << "Execution Time Serie: " << time << endl;

//A->print();


delete thr;  // limpiamos memoria.
delete args;
liberarmemoria( A);
liberarmemoria( B);

cout << "-----------------------------------------------------------" << endl;
cout << "Saliendo del programa..." << endl;
return 0;
}


