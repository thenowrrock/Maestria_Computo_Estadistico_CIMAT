#include <iostream>
#include <stdlib.h>
#define N 5

using namespace std;

int* ApplyFunction(int *arr){
	int *ArrOut = new int [N];  // Memoria dinamica.
	for(int i=0; i<N; i++){
		ArrOut[i] = arr[i]; // Copiamos todos los elementes.
	}
	return &ArrOut[0]; // retornamos la posicion
}

int main(){
	int arr[N] = {1,2,6,0,5};
	int *p = ApplyFunction(arr); // Usamos la funcion.
	cout << *p << endl; // Imprimimos.
	return 0;
}