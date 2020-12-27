#include <stdlib.h> // cout, cin
#include <iostream>
#include <pthread.h> // paralelizar
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <ctime> // time


using namespace std; //rand

int NTHREADS = 4; // definimos los hilos con los que trabajaremos.
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;  // variable para controlar hilos

//---------------------------------Estructuras del programa------------------------------//
// Estructura para las matrices.
struct  matriz { // para definir una matriz.
    int m_filas; // tamanos
    int m_columnas; 
    float **df; // datos
};

matriz resultado, aux_identidad;  // variables auxiliares.

// Estructura para los argumentos de las tareas de los hilos: suma, resta y multiplicacion..
typedef struct { 
    int sup; // limites para los hilos
    int inf;
    matriz mat_1; // matrices a operar
    matriz mat_2;
    matriz resultado; // resultado
} Argumentos;


// Estructura para los argumentos de las tareas de los hilos: inversa..
typedef struct {
    matriz mat; // matriz cuadrada
    matriz aux_identidad;  // matriz identidad.
    int rank; // hilo
    int NTHREADS; // numero de hilos trabajando.
} argumentos_inversa;


//----------------------------------Funciones generales----------------------------------------------
//-------Validaciones de los tamanos de las matrices-------------------------------------------------
int validacion_tamano_suma_resta(matriz A, matriz B){ //tamanos iguales
    if ((A.m_filas==B.m_filas)&& (A.m_columnas==B.m_columnas)){
        return 1;
    }
    else{
        cout << "Los tamanos de las matrices no son adecuados para la operacion" << endl;
        cout << "-----------------------------------------------------------" << endl;
        cout << "Saliendo del programa..." << endl;
        return 0;
    }
}

int validacion_tamano_multiplicacion(matriz A, matriz B){
    if (A.m_columnas==B.m_filas){ // numero de columnas de A tiene que ser igual al numero de filas de B
        return 1;
    }
    else{
        cout << "Los tamanos de las matrices no son adecuados para realizar la multiplicacion." << endl;
        cout << "-----------------------------------------------------------" << endl;
        cout << "Saliendo del programa..." << endl;
        return 0;
    }
}

int validacion_tamano_inversa(int n_1, int m_1){
    if (m_1==n_1){ // verificar que sea una matriz cuadrada.
        return 1;
    }
    else{
        cout << "El tamano de la matriz no es adecuados para realizar la inversa." << endl;
        cout << "-----------------------------------------------------------" << endl;
        cout << "Saliendo del programa..." << endl;
        return 0;
    }
}

//----------------Construccion de matrices utiles-------------------------------------------
// Crear matriz dinamica
matriz iniciar_matriz(matriz mat){ // construimos la matriz utilizando la memoria dinamica.
    mat.df = new float *[mat.m_filas];
    for(int i=0; i<mat.m_filas; i++){
        mat.df[i]=new float[mat.m_columnas];
        }
    return mat;
}

// Imprimir matriz.
void imprimir_matriz(matriz mat){  // imprimimos los elementos de la matriz.
    for (int i=0; i<mat.m_filas; i++){
        for (int j=0; j<mat.m_columnas; j++){
            cout << mat.df[i][j]<< " ";
        }
        cout << endl;
    }
}

// Generar matriz con numeros aleatorios
matriz generar_matriz_aleatoria(matriz mat){  // asignamos valores aleatorias (0,99) a la matriz.
    mat = iniciar_matriz(mat);
    for (int i=0; i< mat.m_filas; i++){
        for (int j=0; j< mat.m_columnas; j++){
            mat.df[i][j]=rand()% 100;
        }
    }
    return mat;
}

// Generar matriz identidad
matriz generar_matriz_identidad(int n){   // asignamos valores iguales a 1 en la diagonal y 0 en otro caso.
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

// Liberar memoria dinamica.
void liberarmemoria(matriz mat){
for (int w = 0;  w< mat.m_filas; w++){
    delete [] mat.df[w] ;
    }
    delete [] mat.df ;
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

// Función suma para asignarla a un hilo.
void* suma_matriz_hilo(void *args) {
    Argumentos *_args = (Argumentos*) args;
    suma_matriz(_args->mat_1, _args->mat_2, _args->resultado, _args->inf, _args->sup);
    pthread_exit(NULL);
    return NULL;
}

// Función resta.
void resta_matriz(matriz mat_1, matriz mat_2, matriz resultado, int inf, int sup){  // sumamos dos matrices.
    for (int i=0; i< resultado.m_filas; i++){
        for (int j = inf; j<sup; j++) {
            resultado.df[i][j] = mat_1.df[i][j]-mat_2.df[i][j];
        }
    }
}

// Función resta para asignarla a un hilo.
void* resta_matriz_hilo(void *args) {
    Argumentos *_args = (Argumentos*) args;
    resta_matriz(_args->mat_1, _args->mat_2, _args->resultado, _args->inf, _args->sup);
    pthread_exit(NULL);
    return NULL;
}

// Función multiplicacion.
void multiplicacion_matriz(matriz mat_1, matriz mat_2, matriz resultado, int inf, int sup){  // sumamos dos matrices.
    for(int row = inf; row < sup; ++row) {
        for(int col = 0; col < resultado.m_columnas; ++col) {
            long int sum = 0.0;
            for(int k = 0; k < mat_1.m_columnas; ++k) {
                sum = sum + (mat_1.df[row][k] * mat_2.df[k][col]);
            }
        resultado.df[row][col] = sum;
        }
    }
}

// Función multiplicación para asignarla a un hilo.
void* multiplicacion_matriz_hilo(void *args) {
    Argumentos *_args = (Argumentos*) args;
    multiplicacion_matriz(_args->mat_1, _args->mat_2, _args->resultado, _args->inf, _args->sup);
    pthread_exit(NULL);
    return NULL;
}

//------------------------------------------------Inversa Secuencia----------------------------------------------
int existencia_pivote(matriz mat, int pivote){
    for (int h=pivote; h<mat.m_filas; ++h){
        if (mat.df[h][pivote]!=0){ // comparamos todos los elementos de la columna para ver si todos son ceros.
            return h; // retornamos el pivote
        }
    }
    return -1; // retornamos -1 si no hay pivotes.
}

// Intercambiamos pivotes.
int intercambia_pivote(matriz mat, int m, int k){
    matriz aux_intercambio;
    aux_intercambio.m_columnas = mat.m_columnas;
    aux_intercambio.m_filas = 1;
    aux_intercambio = iniciar_matriz(aux_intercambio);
    if (m==k){ // si coinciden el número de columnas y el pivote terminamos.
    return 0; // retornamos 0.
    }
    else{
        for(int i=0; i<mat.m_columnas; ++i){ // copiamos los elementos de la fila k
            aux_intercambio.df[1][i]=mat.df[k][i];
        }
        for(int i=0; i<mat.m_columnas; ++i){ // asignamos los elementos de la fila k a la fila m
            mat.df[k][i]=mat.df[m][i];
            mat.df[m][i]=aux_intercambio.df[1][i]; // asignamos los elemenos de la fila m a la fila k
        }
        return 0; // retornemos 0
    }
}

// Dividir los renglones entre el pivote.
int dividir_matriz(matriz mat, matriz aux_identidad, int i){
    for (int j=(i+1); j<mat.m_columnas; ++j){ // normalizamos la matriz
        mat.df[i][j]=mat.df[i][j]/mat.df[i][i];
    }
    for (int j=0; j<mat.m_columnas; ++j){ // normalizamos la matriz identidad.
        aux_identidad.df[i][j]=aux_identidad.df[i][j]/mat.df[i][i];
    }
    mat.df[i][i]=1; // asignamos 1 al pivote
    return 0;
}

// Sumamos el renglón que contiene al pivote con los vectores abajos de el.
int eleminacion_parcial(matriz mat, matriz aux_identidad, int i){
    for (int k=(i+1); k<mat.m_filas; ++k){
        for(int j=0; j<mat.m_filas; ++j){ // aplicamos eliminación gauss-jordan a la matriz identidad.
            aux_identidad.df[k][j] += -aux_identidad.df[i][j]*mat.df[k][i];
        }
        for(int j=(i+1); j<mat.m_columnas; ++j){ // aplicamos eliminación gauss-jordan a la matriz original.
            mat.df[k][j] += -mat.df[i][j]*mat.df[k][i];
        }
        mat.df[k][i]=0; // actualizamos el pivote.
    }
}

// Reducción hacia atras.
int reduccion_hacia_atras(matriz mat, matriz aux_identidad){
    // reducción hacia atras.
    for(int k=(mat.m_columnas-1); k>-1; --k){
        for (int j=0; j<k; ++j){
            for (int h=0; h<mat.m_columnas; ++h){ // realizamos la reducción hacia atras a la matriz U.
                aux_identidad.df[j][h]=aux_identidad.df[j][h]-aux_identidad.df[k][h]*mat.df[j][k];
            }
            mat.df[j][k]=0; // actualizamos los elementos.
        }
    }
    return 0;
}


// Eliminación Gauss-Jordan.
matriz eliminacion_gauss_jordan(matriz mat){
    matriz aux_identidad = generar_matriz_identidad(mat.m_filas);
    int pivotet;
    if (mat.m_filas!= mat.m_columnas) {  // validamos si la matriz es cuadrada.
        cout << "La matriz no es cuadrada, por lo que no se puede calcular la inversa." << endl;
        return aux_identidad;  // retornamos la matriz aumentada 
    }

    for (int i = 0; i < mat.m_filas; ++i) {
        pivotet = existencia_pivote(mat, i);
        if (pivotet==-1){   // validamos la existencia del pivote.
            cout << "La matriz no tiene inversa."<< endl;
            return aux_identidad;
        }
        else{      // intercambiamos el pivote de la matriz original y la matriz identidad.
            
            intercambia_pivote(mat , i, pivotet);
            intercambia_pivote(aux_identidad, i, existencia_pivote(mat, i));
        }

        dividir_matriz(mat, aux_identidad, i);
        eleminacion_parcial(mat, aux_identidad, i);
    }

    reduccion_hacia_atras(mat, aux_identidad);
    return aux_identidad;
}

//------------------------------Inversa Paralelizado-------------------------------------------//
// Intercambiamos pivotes el renglon m y k. 
void intercambia_pivote_p(matriz mat, int m, int k){
    matriz aux_intercambio;
    aux_intercambio.m_columnas = mat.m_columnas;
    aux_intercambio.m_filas = 1;
    aux_intercambio = iniciar_matriz(aux_intercambio);
    for(int i=0; i<mat.m_columnas; ++i){ // copiamos los elementos de la fila k
        aux_intercambio.df[0][i]=mat.df[k][i];
        mat.df[k][i]=mat.df[m][i];

        mat.df[m][i]=aux_intercambio.df[0][i]; // asignamos los elemenos de la fila m a la fila k
    }
}

// Dividir los renglones entre el pivote.
void dividir_matriz_pivote_p(matriz mat, matriz aux_identidad, int i, float tmp){
    for (int j=i; j<mat.m_columnas; ++j){ // normalizamos la matriz
        mat.df[i][j]*=tmp;
    }
    for (int j=0; j<mat.m_columnas; ++j){ // normalizamos la matriz identidad.
        aux_identidad.df[i][j]*=tmp;
    }
}


// Sumamos el renglón que contiene al pivote con los vectores abajos de el.
void eliminacion_parcial_p(matriz mat, matriz aux_identidad, int i, int first_row, int last_row){
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

// Reducción hacia atras.
void reduccion_hacia_atras_p(matriz mat, matriz aux_identidad, int first_row, int last_row){
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

// Función para cordinar los hilos. 
void synchronize(int total_threads) {
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; //objeto de sincronización de tipo mutex
    static pthread_cond_t condvar_in = PTHREAD_COND_INITIALIZER; //objeto de sincronización de tipo condvar
    static pthread_cond_t condvar_out = PTHREAD_COND_INITIALIZER; //objeto de sincronización de tipo condvar
    static int threads_in = 0; //la cantidad de tareas que entraron en la función
    static int threads_out = 0; //la cantidad de tareas que esperan para salir de la función
    
    pthread_mutex_lock(&mutex); //"capturar" el mutex para trabajar con las variables threads_in y threads_out
    
    threads_in++; //aumentar en 1 el número de tareas que llegaron a esta función
    //comprobar el número de tareas recibidas
    if (threads_in >= total_threads) 
    {
        threads_out = 0; //establecer el valor inicial para threads_out
        pthread_cond_broadcast (&condvar_in); //deja que los demás sigan trabajando
    } else 
    //espere hasta que todos los hilos lleguen a esta función
        while (threads_in < total_threads)
        //espere el permiso para continuar: suelte el mutex y espere una señal del condvar, luego "capture" el mutex nuevamente
            pthread_cond_wait(&condvar_in, &mutex);
    
    threads_out++; //aumentar el número de tareas pendientes en 1
    //comprobar el número de tareas recibidas
    if (threads_out >= total_threads)
    {
        threads_in = 0; //establecer el valor inicial para threads_in 
        pthread_cond_broadcast(&condvar_out); //deja que los demás sigan trabajando
    } else //si todavía hay hilos en la cola de espera
        while (threads_out < total_threads) 
        //espere el permiso para continuar: suelte el mutex y espere una señal del condvar, luego "capture" el mutex nuevamente
            pthread_cond_wait(&condvar_out, &mutex);
    
    pthread_mutex_unlock(&mutex); //mutex "apagado"
}


// Eliminación Gauss-Jordan.
int eliminacion_gauss_jordan_p(matriz mat, matriz aux_identidad, int NTHREADS, int rank){
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; // inicializamos el objeto tipo mutex
    float tmp; // variables auxiliares
    int k;
    int first_row; // limites para las tareas de los hilos
    int last_row;
    for (int i = 0; i < mat.m_filas; ++i) {
        if (rank==0){
            k=i;
            for(int j=i+1; j < mat.m_filas; j++){
                if(abs(mat.df[k][i]<abs(mat.df[j][i]))){
                    k=j; // elegimos el renglón con el pivote más grande.
                }
            }

            intercambia_pivote_p(mat , i, k); // actualizamos el pivote.
            intercambia_pivote_p(aux_identidad, i, k); // actualizamos la identidad

            tmp = 1.0/mat.df[i][i]; // valor del pivote
            dividir_matriz_pivote_p(mat, aux_identidad, i, tmp); // dividimos sobre el pivote.
        }
        
        synchronize(NTHREADS); // esperamos a que todos los hilos llegue a este punto.

        first_row = (mat.m_filas- i - 1) * rank; // repartimos los limites de los hilos
        first_row = first_row/NTHREADS + i + 1;
        last_row = (mat.m_filas - i - 1) * (rank + 1);
        last_row = last_row/NTHREADS + i + 1;

        eliminacion_parcial_p(mat, aux_identidad, i, first_row, last_row); // sumamos el renglon del pivote
        synchronize(NTHREADS); // esperamos a que todos los hilos llegue a este punto.										  // y los renglones abajo de el.
   }


    first_row = mat.m_filas * rank; // repartimos los limites de los hilos
    first_row = first_row/NTHREADS;
    last_row = mat.m_filas * (rank + 1);
    last_row = last_row/NTHREADS;

    reduccion_hacia_atras_p(mat, aux_identidad, first_row, last_row); // eliminación hacia atras
    return 0; // terminamos.
}

// Asignamos la tarea de la inversa a un hilo.
void *inversa_p(void* i_arg) {
    argumentos_inversa *arg = (argumentos_inversa*)i_arg;

    eliminacion_gauss_jordan_p(arg->mat, arg->aux_identidad, arg->NTHREADS, arg->rank);

    return NULL;
}

//----------------------------------Funciones para el menu------------------------------------------------------
//----Función para obtener la suma matricial de forma paralelizada.
int ejecutar_suma(matriz A, matriz B){
    int nA = A.m_columnas;
    resultado.m_columnas = A.m_columnas;
    resultado.m_filas = A.m_filas;
    resultado = iniciar_matriz(resultado);

    pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
    Argumentos *args = new Argumentos[NTHREADS];
    int subint = floor(nA/NTHREADS);  // limites para cada hilo

        for(int i=0; i<NTHREADS; i++){
            if(i==NTHREADS-1){       // limites para cada hilo
                args[i].sup = nA;
                args[i].inf = subint*i;
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
            } 
            else{
                args[i].inf = subint*i;
                args[i].sup = subint*(i+1);
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
                }
                pthread_attr_t attr;     // asignamos las tareas a los hilos.
                pthread_attr_init(&attr);
                pthread_create(&thr[i], &attr, suma_matriz_hilo, &args[i]);
                }

                for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
                    pthread_join(thr[i], NULL);
                }
                    
                cout << "La matriz A es:" << endl;
                imprimir_matriz(A);
                cout << "La matriz B es:" << endl;
                imprimir_matriz(B);
                cout << "La suma de matrices es" << endl;
                imprimir_matriz(resultado);
                delete thr;  // limpiamos memoria.
                delete args;
                liberarmemoria(A);
                liberarmemoria(resultado);
            return 0;
}

//----Función para obtener la resta matricial de forma paralelizada.
int ejecutar_resta(matriz A, matriz B){
    int nA = A.m_columnas;
    resultado.m_columnas = A.m_columnas;
    resultado.m_filas = A.m_filas;
    resultado = iniciar_matriz(resultado);

    pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
    Argumentos *args = new Argumentos[NTHREADS];
    int subint = floor(nA/NTHREADS);  // limites para cada hilo

        for(int i=0; i<NTHREADS; i++){
            if(i==NTHREADS-1){       // limites para cada hilo
                args[i].sup = nA;
                args[i].inf = subint*i;
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
            } 
            else{
                args[i].inf = subint*i;
                args[i].sup = subint*(i+1);
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
                }
                pthread_attr_t attr;     // asignamos las tareas a los hilos.
                pthread_attr_init(&attr);
                pthread_create(&thr[i], &attr, resta_matriz_hilo, &args[i]);
                }

                for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
                    pthread_join(thr[i], NULL);
                }
                    
                cout << "La matriz A es:" << endl;
                imprimir_matriz(A);
                cout << "La matriz B es:" << endl;
                imprimir_matriz(B);
                cout << "La resta de matrices es" << endl;
                imprimir_matriz(resultado);
                delete thr;  // limpiamos memoria.
                delete args;
                liberarmemoria(A);
                liberarmemoria(resultado);
            return 0;
}

//----Función para obtener la multiplicación matricial de forma paralelizada.
int ejecutar_multiplicacion(matriz A, matriz B){
    int nA = A.m_filas;
    resultado.m_columnas = B.m_columnas;
    resultado.m_filas = A.m_filas;
    resultado = iniciar_matriz(resultado);

    pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
    Argumentos *args = new Argumentos[NTHREADS];
    int subint = floor(nA/NTHREADS);  // limites para cada hilo

        for(int i=0; i<NTHREADS; i++){
            if(i==NTHREADS-1){       // limites para cada hilo
                args[i].sup = nA;
                args[i].inf = subint*i;
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
            } 
            else{
                args[i].inf = subint*i;
                args[i].sup = subint*(i+1);
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
                }
                pthread_attr_t attr;     // asignamos las tareas a los hilos.
                pthread_attr_init(&attr);
                pthread_create(&thr[i], &attr, multiplicacion_matriz_hilo, &args[i]);
                }

                for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
                    pthread_join(thr[i], NULL);
                }
                    
                cout << "La matriz A es:" << endl;
                imprimir_matriz(A);
                cout << "La matriz B es:" << endl;
                imprimir_matriz(B);
                cout << "La multiplicacion resultante es" << endl;
                imprimir_matriz(resultado);
                delete thr;  // limpiamos memoria.
                delete args;
                liberarmemoria(A);
                liberarmemoria(resultado);
            return 0;
}

//----Función para obtener la inversa matricial de forma paralelizada.
int ejecutar_inversa(matriz A){
    int nA = A.m_columnas;
    aux_identidad = generar_matriz_identidad(A.m_filas);
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

        pthread_create(threads+1, 0, inversa_p , args+i);
        }   

    for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
        pthread_join(threads[i], 0);
    }

    imprimir_matriz(aux_identidad);
    liberarmemoria(A);
    liberarmemoria(aux_identidad);

    delete threads;  // limpiamos memoria.
    delete args;
    return 1;

}

// -------------Menu de opciones--------------------------------------
int ejecutar(matriz A, char operacion, matriz B){
    switch(operacion)
    {
        case '+':
            cout << "---------------------------------------------------------------" << endl;
            if (validacion_tamano_suma_resta(A, B)==1){
            ejecutar_suma(A, B);
            }
            else{
                return 0;
            }
            break;
        case '-':
            cout << "---------------------------------------------------------------" << endl;
            if (validacion_tamano_suma_resta(A, B)==1){
            ejecutar_resta(A, B);
            }
            else{
                return 0;
            }
            break;
        case '*':
            cout << "---------------------------------------------------------------" << endl;
            if (validacion_tamano_multiplicacion(A, B)==1){
            ejecutar_multiplicacion(A, B);
            }
            else{
                return 0;
            }            
            break;
        case 'i':
            if (validacion_tamano_inversa(A.m_filas, A.m_columnas)==1){
                ejecutar_inversa(A);
            }
            else{
                return 0;
            }
            break;
        case '0':
            cout << "Saliendo del programa..." << endl;
            break;
        default:
            cout << "Ingresaste mal la operacion." << endl;
            cout << "Saliendo del programa..." << endl;
    }
}

