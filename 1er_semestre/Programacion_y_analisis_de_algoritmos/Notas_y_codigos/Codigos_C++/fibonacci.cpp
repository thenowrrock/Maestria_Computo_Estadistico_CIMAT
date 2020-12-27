#include <iostream>
#include <ctime>
#include <stdlib.h>


using namespace std;

long int fibonacci_iter(int n){
	int f=1;
	int aux=1;
	for(int i=3; i<=n; i++){
		aux += f;
		f= aux-f;
	}
	return aux;
}

long int fibonacci_rec(int n){
	if(n==1|| n==2){
		return 1;
	}
	return fibonacci_rec(n-1)+fibonacci_rec(n-2);
}

int main(int argc, char *argv[]){
	int n =atoi(argv[1]);
	long int fib;
	time_t t;
	t = clock();
	fib = fibonacci_iter(n);
	cout << fib << endl;
	cout << (double)(clock()-t)/CLOCKS_PER_SEC << endl;

	t = clock();
	fib = fibonacci_rec(n);
	cout << fib << endl;
	cout << (double)(clock()-t)/CLOCKS_PER_SEC << endl;
	return 0;
}
