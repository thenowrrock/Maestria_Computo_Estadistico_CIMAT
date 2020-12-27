#include <pthread.h>
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <ctime>
#include <iostream>
using namespace std;

#define HAVE_STRUCT_TIMESPEC
#define NTHREADS 4

 long int suma_par = 0;

struct Argumentos{
	int sup;
	int inf;
};

long int suma_secuencial(int n){
	long int suma = 0;
	for(int i=1;i<=n;i++){
		suma += i;
	}
	return suma;
}

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void* suma_paralela(void *args){
	Argumentos *_args = (Argumentos*) args;
	for(int i=_args->inf; i<=_args->sup; i++){
		pthread_mutex_lock(&mutex);
		suma_par += i;
		pthread_mutex_unlock(&mutex);
	}
	return NULL;
}

int main(int argc, char *argv[]){
	int n = 100000000;

	unsigned t0, t1;
	t0=clock();
	long int suma =  suma_secuencial(n);
	t1 = clock();

	double time = (double(t1-t0)/CLOCKS_PER_SEC);
	cout << "Execution Time: " << time << endl;	

	printf("El valor de la suma secuencial es: %ld\n",suma);

	t0=clock();
	pthread_t *thr = new pthread_t[NTHREADS];
	Argumentos *args = new Argumentos[NTHREADS];
	int subint = floor(n/NTHREADS);

	for(int i=0; i<NTHREADS; i++){
		if(i==NTHREADS-1){
			args[i].sup = n;
		       	args[i].inf = subint*i+1;	
		}else{
			args[i].inf = subint*i+1;
			args[i].sup = subint*(i+1);
		}
		pthread_attr_t attr;
		pthread_attr_init(&attr);
		pthread_create(&thr[i],&attr, suma_paralela, &args[i]);
	}
	
	for(int i=0;i<NTHREADS;i++){
		pthread_join(thr[i], NULL);
	}
	t1 = clock();

	time = (double(t1-t0)/CLOCKS_PER_SEC);
	cout << "Execution Time: " << time << endl;	

	printf("La suma paralela es: %ld\n",suma_par);

	delete thr;
	delete args;
	return 0;
}



