#include <iostream>
#include <stdlib.h> // rand
#include <math.h> // pow, sqrt 
#include <vector>  // vector

using namespace std; //* cout, endl  *//

namespace stats{ //Encapsulamos las funciones solicitadas.
	// Function para calcular la media de los datos. 
	float mean_calculate(vector<int> &v){
	float mean_muestral;
		for(int i=0; i<(v.size()-1); ++i){
			mean_muestral+=v[i]; // Sumamos todos los elementos.
		}
		return mean_muestral/(v.size()-1); // Dividimos el resultado entre el número total.
	}

	// Función para calcular la varianza de los datos. 
	// se ocupa la media de la función anteior.
	float varianza_calculate(vector<int> v){
		float mean_muestral = mean_calculate(v), var_muestral,
		x_i;
		for(int i=0; i<(v.size()-1); ++i){
			x_i = v[i]-mean_muestral; //Diferencia entre la media.
			var_muestral+=pow(x_i,2);// Elevamos al cuadrado.
		}
		var_muestral = var_muestral/(v.size()-2); //Dividimos entre n-1.
		return var_muestral;
	}

	// Función para calcular la desviación estandar.
	// Se ocupa la función de varianza.
	float desviacion_estandar_muestral(vector<int> v){
		return sqrt(varianza_calculate(v)); // Por definición.
	}

	// Función para calcular la mediana.
	vector<int> mediana_muestral(vector<int> v){
		int i=0, j=0, aux, n=v.size()-1, bandera=0;
		vector<int> resultado;
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
		if(v.size()%2!=0) { // Si nes par entonces tiene una mediana.
       		resultado.push_back(v[n/2]);
    	} 
    	else { // Si n es impar, tiene dos mediadas (por definicion).
    		resultado.push_back(v[n/2]);
    		resultado.push_back(v[n/2-1]);
    		}
    	return resultado; // retorna un vector con las medianas.
	}

	// Función para calculara la moda. 
	vector<int> moda_muestral(vector<int> v){
		vector<int> vector_max;
		int contador, max=1;   // Inicializamos la moda, y el número
		for(int i=0; i<(v.size()-2); i++){ // modas.
			contador=1;
			for(int j=i+1; j<v.size()-1;j++){
				if(v[i]==v[j]){ // Conramos cuantas veces esta.
					contador++;
				} 				
			}
			if(contador>max){ // Si es mayor que el maximo pasado
				vector_max.clear(); // entonces crear otra moda.
				vector_max.push_back(v[i]);
				max=contador; // Asignamos el mayor maximo.
			} else if(contador==max){
				vector_max.push_back(v[i]); // Agreamos si hay dos
			} else{							// maximas.
					// No hagas nada.
			}
		}
		return vector_max; // Retorna un vector de las medias.

	}
}

using namespace stats;

int main(){
	vector<int> vector, resultado_v;
	float resultado; 
	int n;
	for(int i=0; i<200; i++){
		vector.push_back(1+rand()%(149)+100);
	}
	n = vector.size();
	vector.push_back(n);

	cout << "Sean generado "<<vector.size()<<" numeros aleatorios. Los cuales son:" << endl; 
    for (int i=0; i<n; ++i){
		if (i==(n-1)){
			cout << vector[i] << endl;
		} 
		else{
			cout << vector[i] << " "; 
		}
    }
    cout<<"El tamano del vector es"<< vector[n+1]<<endl;
    cout<< "-----------------Resultados--------------------";
	resultado = mean_calculate(vector);
	// Imprimimos la media.
	cout << "\n-La media de los números aleatorios es: \n"<< resultado << endl;

	resultado = varianza_calculate(vector);
	// Imprimimos la varianza.
	cout << "-La varianza de los números aleatorios es:\n "<< resultado << endl;
	
	resultado = desviacion_estandar_muestral(vector);
	// Imprimimos la desviacion estandar.
	cout << "-La desviación estandar de los números aleatorios es:\n "<< resultado << endl;

	resultado_v = mediana_muestral(vector); // retornamos las medianas.
	// Imprimimos la mediana.
	if(resultado_v.size()%2!=0) { // Si nes par entonces tiene una mediana.
       		cout <<"-EL valor de la mediana es : "<< resultado_v[0] <<endl;
    	} 
    	else { // Si n es impar, tiene dos mediadas (por definicion).
    		cout <<"-Existen dos medianas en los datos:"<<endl;
        	cout <<"-----La primera mediana es :"<< resultado_v[0] << endl;
        	cout <<"-----La segunda mediana es :"<< resultado_v[1] <<endl;
    }
    resultado_v.clear(); // limpiamos el vector de resultados.
	resultado_v = moda_muestral(vector);
	// Imprimimos la moda.
	if(resultado_v.size()==1){ // Si hay una moda.
		cout<<"-La moda es"<<resultado_v[0]<< endl; 
	} 
	else{
		cout<<"-Existen más de una moda. Las cuales son:" << endl;
		for (int i=0; i<resultado_v.size(); ++i){// Imprimimos todas las modas.
			cout << "-----La moda #" << i << " es " << resultado_v[i]<<endl; 
  		}
  	}
	cout<< "--------------------Fin-------------------------"<<endl;
	return 0;
}
