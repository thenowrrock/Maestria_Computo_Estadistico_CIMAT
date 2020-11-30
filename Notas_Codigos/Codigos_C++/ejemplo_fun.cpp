#include <iostream>

using namespace std;


// n! = n*(n-1)*...*1
namespace iterativo{ 
	int factorial(int n){
		if(n<0){
			cout << "El factorial no puede ser calculado" << endl;
			return -1;
		}
		int factorial = 1;
		while(n>1){
			factorial *= n--;
		}
		return factorial;
	}

	void print(){
		cout << "Hola mundo iterativo" << endl;
	}
}

namespace recursivo{
	int factorial(int n){

		if(n<0){
			cout << "El factorial no se puede calcular" << endl;
			return -1;
		}
	
		if(n==0 || n==1){
			return 1;
		}
	
		return n*factorial(n-1);
	}

	void print(){
		cout << "Hola mundo recursivo" << endl;
	}

}

using namespace iterativo;

int main(){

	int n=4, resultado;

	resultado = factorial(n);
	cout << resultado << endl;

	int (*norberto)(int) = &recursivo::factorial;
	resultado = norberto(n);
	cout << resultado << endl;

	resultado = recursivo::factorial(n);
	cout << resultado << endl;

	print();
	recursivo::print();

	return 0;
}

