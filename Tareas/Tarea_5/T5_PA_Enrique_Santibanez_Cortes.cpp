// ------------------------------------Documentacion:------------------------------------------------------
// Crear un programa en C/C++ sume todos los números del 1 al n de forma paralelizada,
// modificando lo versión de clase para que sea más eficiente.
// - Agregue los tiempos de ejecución para comparar versiones.
//----------------------------------------------------------------------------------------------------------
#include <pthread.h> // paralelizar
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <ctime> // time 
#include <iostream> // cout 

#define HAVE_STRUCT_TIMESPEC
#define NTHREADS 4 // numeros de hilos
using namespace std;

long int suma_par = 0; // suma total

struct Argumentos{ // definimos la estructura
	int sup;
	int inf;
};

long int suma_secuencial(int n){ // suma secuencial.
	long int suma = 0;
	for(int i=1;i<=n;i++){
		suma += i;
	}
	return suma;
}

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; // inicializamos para ocuparlo en las secciones criticas

void* suma_paralela(void *args){
	Argumentos *_args = (Argumentos*) args;
	long int suma2 = 0; 				// iniciamilizamos la variable suma2 

	for(int i=_args->inf; i<=_args->sup; i++){
		
		suma2 += i; // sumamos la variable auxiliar.
		// pthread_mutex_lock(&mutex);   // cambio de la versión de la clase
		// suma_par += suma2;			 // cambio de la versión de la clase
		// pthread_mutex_unlock(&mutex); // cambio de la versión de la clase
	}
		pthread_mutex_lock(&mutex); // sumamos las sumas parciales considerando secciones criticas
		suma_par += suma2;
		pthread_mutex_unlock(&mutex);

    pthread_exit(NULL);    
	return NULL;
}

int main(int argc, char *argv[]){
	unsigned t0, t1; // variables de tiempo
	int n = 1000000000;	// inicializamos n.

	t0 =clock();        // medimos el tiempo de ejecución de la suma secuencial
	long int suma =  suma_secuencial(n);
	t1 = clock();

	double time = (double(t1-t0)/CLOCKS_PER_SEC); // imprimimos el tiempo.
	cout << "Execution Time: " << time << endl;	
	
	printf("El valor de la suma secuencial es: %ld\n",suma); // resultado.
	
	t0=clock();         // medimos el tiempo de ejecución de la suma paralela
	pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
	Argumentos *args = new Argumentos[NTHREADS]; // inicializamos las estructura para los hilos
	
	int subint = floor(n/NTHREADS);  // limites para cada hilo

	for(int i=0; i<NTHREADS; i++){
		if(i==NTHREADS-1){       // limites para cada hilo
			args[i].sup = n;
		       	args[i].inf = subint*i+1;	
		}else{
			args[i].inf = subint*i+1;
			args[i].sup = subint*(i+1);
		}
		pthread_attr_t attr;     // asignamos las tareas a los hilos.
		pthread_attr_init(&attr);
		pthread_create(&thr[i],&attr, suma_paralela, &args[i]);
	}

	for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
		pthread_join(thr[i], NULL);
	}
	t1 = clock();    // imprimimos el tiempo.
	time = (double(t1-t0)/CLOCKS_PER_SEC); 
	cout << "Execution Time: " << time << endl;	
	
	printf("La suma paralela es: %ld\n",suma_par); // imprimimos resultados.

	delete thr;  // limpiamos memoria.
	delete args;
	return 0;
}



// ------------------------------------Comparación:------------------------------------------------------
// - Resultado para n=1000000000.
// 
// - Versión secuencial.
// - Execution Time secuencial : 2.8736
// - El valor de la suma secuencial es: 500000000500000000
//
// - Versión paralela nueva.
// - Execution Time paralela versión nueva: 3.42945
// - La suma paralela es: 500000000500000000
//
// - Versión paralela clase.
// - Execution Time paralela versión de clase: 60.5356+ 
// - La suma paralela es: 500000000500000000
//----------------------------------------------------------------------------------------------------------

// Concluimos que existe una mejora en la eficiencia con esta versión paralela.