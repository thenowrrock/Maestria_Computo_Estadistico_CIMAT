#include <stdlib.h> // cout, cin
#include <iostream>
#include <pthread.h> // paralelizar
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <ctime> // time


using namespace std; //rand
#define HAVE_STRUCT_TIMESPEC
// #define NTHREADS 4// numeros de hilos

struct  matriz {
    int m_filas;
    int m_columnas;
    float **df;
};

typedef struct { // definimos la estructura
    int sup;
    int inf;
    matriz mat_1;
    matriz mat_2;
    matriz resultado;
} Argumentos;


int nA=4; // inicializamos los tamaños de la matriz.
matriz A, B, C;

//----------------------------------Funciones generales---------------------------------------------
matriz iniciar_matriz(matriz mat){ // construimos la matriz utilizando la memoria dinamica.
    mat.df = new float *[mat.m_filas];
    for(int i=0; i<mat.m_filas; i++){
        mat.df[i]=new float[mat.m_columnas];
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



//------------------------------Inversa----------------//

typedef struct {
    matriz mat; //исходная матрица
    matriz aux_identidad; //матрица, в которой будет обратная
    int rank; //номер потока
    int NTHREADS; //общее число потоков
} argumentos_inversa;


matriz generar_matriz_identidad(int n){   // asignamos valores aleatorias (0,99) a la matriz.
    matriz aux_identidad;
    aux_identidad.m_columnas = n;
    aux_identidad.m_filas = n;
    aux_identidad = iniciar_matriz(aux_identidad);
    for (int i = 0; i < n; ++i) { // creamos una matriz con unos en la diagonal y ceros en los demas.
        for (int j = 0; j < n; ++j) {
            if (i == j) {
                aux_identidad.df[i][j] = 1;
            }
            else {
                aux_identidad.df[i][j] = 0;
            }
        }
    }
    return aux_identidad;
}

int existencia_pivote(matriz mat, int pivote){
    for (int h=pivote; h<mat.m_filas; ++h){
        if (mat.df[h][pivote]!=0){ // comparamos todos los elementos de la columna para ver si todos son ceros.
            return h; // retornamos el pivote
        }
    }
    return -1; // retornamos -1 si no hay pivotes.
}

// Intercambiamos pivotes el renglon m y k. 
void intercambia_pivote(matriz mat, int m, int k){
    matriz aux_intercambio;
    aux_intercambio.m_columnas = mat.m_columnas;
    aux_intercambio.m_filas = 1;
    aux_intercambio = generar_matriz_aleatoria(aux_intercambio);
    for(int i=0; i<mat.m_columnas; ++i){ // copiamos los elementos de la fila k
        aux_intercambio.df[0][i]=mat.df[k][i];
        mat.df[k][i]=mat.df[m][i];

        mat.df[m][i]=aux_intercambio.df[0][i]; // asignamos los elemenos de la fila m a la fila k
    }
}

void dividir_matriz_pivote(matriz mat, matriz aux_identidad, int i, float tmp){
    for (int j=i; j<mat.m_columnas; ++j){ // normalizamos la matriz
        mat.df[i][j]*=tmp;
    }
    for (int j=0; j<mat.m_columnas; ++j){ // normalizamos la matriz identidad.
        aux_identidad.df[i][j]*=tmp;
    }
}


void reduccion_hacia_atras(matriz mat, matriz aux_identidad, int first_row, int last_row){
    // reducción hacia atras.
    double tmp;
    for (int k=first_row; k<last_row; k++){
        for(int i=(mat.m_columnas-1); i>=0; i--){
            tmp= aux_identidad.df[i][k];
            for (int j=i+1; j<mat.m_columnas; j++){ // realizamos la reducción hacia atras a la matriz U.
                tmp-=mat.df[i][j]*aux_identidad.df[j][k];
            }
            aux_identidad.df[i][k]=tmp; // actualizamos los elementos.
        }
    }
}

void eleminacion_parcial(matriz mat, matriz aux_identidad, int i, int first_row, int last_row){
    double tmp;
    for (int j=first_row; j<last_row; j++){
        tmp = mat.df[j][i];
        for(int k=0; k<mat.m_filas; k++){ // aplicamos eliminación gauss-jordan a la matriz identidad.
            aux_identidad.df[j][k] -= aux_identidad.df[i][k]*tmp;
        }
        for(int k=i; k<mat.m_columnas; k++){ // aplicamos eliminación gauss-jordan a la matriz original.
            mat.df[j][k] -= mat.df[i][k]*tmp;
        }
    }
}

void synchronize(int total_threads) //дождаться в текущем потоке остальных потоков (из общего числа total_threads)
{
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; //объект синхронизации типа mutex
    static pthread_cond_t condvar_in = PTHREAD_COND_INITIALIZER; //объект синхронизации типа condvar
    static pthread_cond_t condvar_out = PTHREAD_COND_INITIALIZER; //объект синхронизации типа condvar
    static int threads_in = 0; //число пришедших в функцию задач
    static int threads_out = 0; //число ожидающих выхода из функции задач
    
    pthread_mutex_lock(&mutex); //"захватить" mutex для работы с переменными threads_in и threads_out
    
    threads_in++; //увеличить на 1 количество прибывших в эту функцию задач
    //проверяем количество прибывших задач
    if (threads_in >= total_threads) //если текущий поток пришёл последним
    {
        threads_out = 0; //устанавливаем начальное значение для threads_out
        pthread_cond_broadcast (&condvar_in); //разрешаем остальным продолжать работу
    } else //если есть ещё не пришедшие потоки
    //ожидаем, пока в эту функцию не придут все потоки
        while (threads_in < total_threads)
        //ожидаем разрешения продолжить работу: освободить mutex и ждать сигнала от condvar, затем "захватить" mutex опять
            pthread_cond_wait(&condvar_in, &mutex);
    
    threads_out++; //увеличить на 1 количество ожидающих выхода задач
    //проверяем количество прибывших задач
    if (threads_out >= total_threads)
    {
    //текущий поток пришёл в очередь последним
        threads_in = 0; //устанавливаем начальное значение для threads_in 
        pthread_cond_broadcast(&condvar_out); //разрешаем остальным продолжать работу
    } else //если в очереди ожидания ещё есть потоки
    //ожидаем, пока в очередь ожидания не придёт последний поток
        while (threads_out < total_threads) 
        //ожидаем разрешения продолжить работу: освободить mutex и ждать сигнала от condvar, затем "захватить" mutex опять
            pthread_cond_wait(&condvar_out, &mutex);
    
    pthread_mutex_unlock(&mutex); //"освободить" mutex
}


// Eliminación Gauss-Jordan.
int eliminacion_gauss_jordan(matriz mat, matriz aux_identidad, int NTHREADS, int rank){
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; //объект синхронизации типа mutex
    float tmp;
    int k;
    int first_row;
    int last_row;
    for (int i = 0; i < mat.m_filas; ++i) {
        if (rank==0){   // validamos la existencia del pivote.
            // cout<< "entro rank =0" << endl;
            k=i;
            for(int j=i+1; j < mat.m_filas; j++){
                if(abs(mat.df[k][i]<abs(mat.df[j][i]))){
                    k=j;
                }
            }
            intercambia_pivote(mat , i, k);
            intercambia_pivote(aux_identidad, i, k);

            tmp = 1.0/mat.df[i][i];
            dividir_matriz_pivote(mat, aux_identidad, i, tmp);
            // cout<< "salio rank =0" << endl;

        }
        
        synchronize(NTHREADS);

        first_row = (mat.m_filas- i - 1) * rank;
        first_row = first_row/NTHREADS + i + 1;
        last_row = (mat.m_filas - i - 1) * (rank + 1);
        last_row = last_row/NTHREADS + i + 1;
        cout << first_row << last_row << endl;
        eleminacion_parcial(mat, aux_identidad, i, first_row, last_row);
        synchronize(NTHREADS);
   }
    // cout << "avion" << endl;
    // cout<< "entro reduccion =0" << endl;

    first_row = mat.m_filas * rank;
    first_row = first_row/NTHREADS;
    last_row = mat.m_filas * (rank + 1);
    last_row = last_row/NTHREADS;

    reduccion_hacia_atras(mat, aux_identidad, first_row, last_row);
    // cout<< "entro reduccion =0" << endl;
    cout << "fin" << endl;
    // imprimir_matriz(aux_identidad); // imprimimos la inversa.
    return 0; // retornamos la inversa.
}

void liberarmemoria(matriz mat){
for (int w = 0;  w< mat.m_filas; w++){
    delete [] mat.df[w] ;
    }
    delete [] mat.df ;
}


struct timespec begin, end;

double thread_time = 0, thread_time_1 = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *inversa_p(void* i_arg) {
argumentos_inversa *arg = (argumentos_inversa*)i_arg;

eliminacion_gauss_jordan(arg->mat, arg->aux_identidad, arg->NTHREADS, arg->rank);

return NULL;
}



int main(){
int NTHREADS =3;
double elapsed;

A.m_columnas = nA;
A.m_filas = nA;

A = generar_matriz_aleatoria(A);
matriz aux_identidad = generar_matriz_identidad(nA);
imprimir_matriz(A);
clock_gettime(CLOCK_MONOTONIC, &begin);


pthread_t *threads = NULL;
threads = (pthread_t*)malloc(NTHREADS * sizeof(pthread_t));

argumentos_inversa *args = NULL;
args = (argumentos_inversa*)malloc(NTHREADS * sizeof(argumentos_inversa));

int subint = floor(nA/NTHREADS);  // limites para cada hilo

	for(int i=0; i<NTHREADS; i++){
            args[i].mat = A;
            args[i].aux_identidad = aux_identidad;
            args[i].rank = i;
            args[i].NTHREADS = NTHREADS;
        // pthread_attr_t attr;     // asignamos las tareas a los hilos.
		// pthread_attr_init(&attr);
		//pthread_create(&thr[i], &attr, suma_matriz_hilo, &args[i]);
        pthread_create(threads+1, 0, inversa_p , args+i);

    }


    // medimos el tiempo de ejecución de la suma paralela
for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
    pthread_join(threads[i], 0);
    // cout << "join_pth" <<endl;
}

clock_gettime(CLOCK_MONOTONIC, &end);
elapsed = end.tv_sec - begin.tv_sec;
elapsed += (end.tv_nsec - begin.tv_nsec) / 1000000000.0;
cout << "Execution Time Paralela: " << elapsed << endl;
imprimir_matriz(aux_identidad);

// cout << "Suma" << endl;

delete threads;  // limpiamos memoria.
delete args;
liberarmemoria( A);
liberarmemoria(aux_identidad);


cout << "-----------------------------------------------------------" << endl;
cout << "Saliendo del programa..." << endl;
return 0;
}


