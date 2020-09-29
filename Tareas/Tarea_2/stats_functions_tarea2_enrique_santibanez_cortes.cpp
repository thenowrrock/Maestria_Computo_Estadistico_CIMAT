// ------------------------------------Documentacion:------------------------------------------------------
// Crear un programa en C/C++ que genere un vector de tamaño 200 con numeros enteros aleatorios sobre 
// el intervalo [100,250] (Guardar el arreglo en una estructura de nombre vector que almacene el tamano
// del arreglo y el arreglo mismo), y codificar una función para cada una de los siguientes calculos 
//(con un único argumento de tipo vector, y de retorno el valor calculado):
//------Promedio
//------Moda
//------Varianza 
//------Desviacion estandar
// Encapsular cada una de estas funciones dentro de un namespace llamado stats.  
// Recomendaciones: las librerías stdlib.h y math.h tienen algunas funciones para generar números aleatorios 
//y operaciones matemáticas que los pueden ayudar.
//----------------------------------------------------------------------------------------------------------
#include <iostream>
#include <stdlib.h> // rand
#include <math.h> // pow, sqrt 

using namespace std; //* cout, endl  *//

namespace stats{ //Encapsulamos las funciones solicitadas.
	// Function para calcular la media de los datos. 
	float mean_calculate(int v[201]){
	float mean_muestral;
		for(int i=0; i<v[201]; ++i){
			mean_muestral+=v[i]; // Sumamos todos los elementos.
		}
		return mean_muestral/v[201]; // Dividimos el resultado entre el número total.
	}

	// Función para calcular la varianza de los datos. 
	// se ocupa la media de la función anteior.
	float varianza_calculate(int v[201]){
		float mean_muestral = mean_calculate(v), var_muestral,
		x_i;
		for(int i=0; i<v[201]; ++i){
			x_i = v[i]-mean_muestral; //Diferencia entre la media.
			var_muestral+=pow(x_i,2);// Elevamos al cuadrado.
		}
		return var_muestral/(v[201]-1);
	}

	// Función para calcular la desviación estandar.
	// Se ocupa la función de varianza.
	float desviacion_estandar_muestral(int v[201]){
		return sqrt(varianza_calculate(v)); // Por definición.
	}

	// Función para calcular la mediana.
	int mediana_muestral(int v[201]){
		int i=0, j=0, aux, n=v[201], bandera=0;
		for(i=(n-1);i>0&&bandera==0;i--) { // Ordenamos el vector.
			bandera==1;
			for(j=0;j<i;j++) {
	            if(v[j]>v[j+1]) {
	                aux = v[j];
	                v[j] = v[j+1];
	                v[j+1]=aux;
	                bandera==0;
	            }
	        }
		}
    	return v[n/2]; // retorna el valor a la mitad.
	}

	// Función para calculara la moda. 
	int moda_muestral(int v[201]){
		int contador, max=1, vector_max, h;// Inicializamos la moda, y el número
		for(int i=0; i<(v[201]-1); i++){ // modas.
			contador=1;
			for(int j=i+1; j<v[201];j++){
				if(v[i]==v[j]){ // Conramos cuantas veces esta.
					contador++;
				} 				
			}
			if(contador>max){ // Si es mayor que el maximo pasado
				vector_max=v[i]; // entonces crear otra moda.
				max=contador; // Asignamos el mayor maximo.
			}
		}
		return vector_max; // Retorna un vector de las medias.

	}
}

using namespace stats; // llamamos la encapsulacion

int main(){
	int vector[201]; // estructura del vector.
	cout << "Los numeros aleatorios generados son:" << endl; 
	for(int i=0; i<200; i++){
		vector[i]=1+rand()%(149)+100;
		if(i==(200-1)){
		cout << vector[i] << endl;
		}else cout << vector[i] << " "; 
	}
	vector[201] = 200; //el tamano del vector esta en la ultima fila.
	// Utilizamos las funciones de la capsula e imprimimos los resultados:
    cout<< "-----------------Resultados--------------------";
	// Imprimimos la media.
	cout << "\n-La media de los números aleatorios es: \n"<< mean_calculate(vector) << endl;

	// Imprimimos la varianza.
	cout << "-La varianza de los números aleatorios es:\n "<< varianza_calculate(vector) << endl;
	
	// Imprimimos la desviacion estandar.
	cout << "-La desviación estandar de los números aleatorios es:\n "<< desviacion_estandar_muestral(vector) << endl;

	// Imprimimos la mediana.
    cout <<"-EL valor de la mediana es :\n"<< mediana_muestral(vector) <<endl;
	
	// Imprimimos la moda.
	cout << "-La moda es:\n" << moda_muestral(vector) << endl; 
	
	cout<< "--------------------Fin-------------------------"<<endl;
	return 0;
}
