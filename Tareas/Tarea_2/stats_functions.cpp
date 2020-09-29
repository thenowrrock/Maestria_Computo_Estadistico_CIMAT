#include <iostream>
#include <stdlib.h> // rand
#include <math.h> // pow
#include <vector>  // vector

using namespace std; //* cout, endl  *//

namespace stats{
	float mean_calculate(vector<int> &v, int is_print=0){
		float mean_muestral;
		int n=v.size();
		for(int i=0; i<v.size(); ++i){
			mean_muestral+=v[i];
		}
		mean_muestral = mean_muestral/n;
		if(is_print==1){
			cout << "\n-La media de los números aleatorios es: \n"<< mean_muestral<< endl;
		}
		return mean_muestral;
	}

	float varianza_calculate(vector<int> v, int is_print){
		float mean_muestral = mean_calculate(v,0), var_muestral,
		x_i;
		int n=v.size();
		for(int i=0; i<v.size(); ++i){
			x_i=v[i]-mean_muestral;
			var_muestral+=pow(x_i,2);
		}
		var_muestral = var_muestral/(n-1);
		if(is_print==1){
			cout << "-La varianza de los números aleatorios es:\n "<< var_muestral<< endl;
		}
		return var_muestral;
	}

	float desviacion_estandar_muestral(vector<int> v){
		float var_muestral = varianza_calculate(v,0), sd_muestral;

		sd_muestral = sqrt(var_muestral);
		cout << "-La desviación estandar de los números aleatorios es:\n "<< sd_muestral << endl;
		return sd_muestral;
	}

	void mediana_muestral(vector<int> v){
		int i=0, j=0, aux, n=v.size(), bandera;
		bandera=0;
		for(i=(n-1);i>0&&bandera==0;i--) {
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
		
		 if(n%2!=0) {
       		cout <<"-EL valor de la mediana es : "<< v[n/2] <<endl;
    	} 
    	else {
    		cout <<"-Existen dos medianas en los datos:"<<endl;
        	cout <<"-----La primera mediana es :"<< v[n/2] << endl;
        	cout <<"-----La segunda mediana es :"<< v[(n/2)-1] <<endl;
    	}
	}

	void moda_muestral(vector<int> v){
		vector<int> vector_max;
		int contador, max=1, moda_num=0,h;
		for(int i=0; i<(v.size()-1); i++){
			contador=1;
			for(int j=i+1; j<v.size();j++){
				if(v[i]==v[j]){
					contador++;
				} 				
			}
			if(contador>max){
				vector_max.clear();
				vector_max.push_back(v[i]);
				max=contador;
				moda_num=0;
				
			} else if(contador==max){
				moda_num++;
				vector_max.push_back(v[i]);
			} else{
				h=1;
			}
		}

		if(vector_max.size()==1){
			cout<<"-La moda es"<<vector_max[0]<< endl; 
		} 
		else{
			cout<<"-Existen más de una moda. Las cuales son:" << endl;
			cout<<"-La frecuencia que aparecen es " <<max<<endl;
			for (int i=0; i<vector_max.size(); ++i){
				cout << "-----La moda #" << i << " es " << vector_max[i]<<endl; 
    		}
		}
	}
}
using namespace stats;

int main(){
	int i, n;
	vector<int> numeros_aleatorios,prueba; 
	for(i=0; i<200; i++){
		numeros_aleatorios.push_back(1+rand()%(149)+100);
	}

	cout << "Sean generado "<<numeros_aleatorios.size()<<" numeros aleatorios. Los cuales son:" << endl; 
    for (int i=0; i<numeros_aleatorios.size(); ++i){
		if (i==(numeros_aleatorios.size()-1)){
			cout << numeros_aleatorios[i] << endl;
		} 
		else{
			cout << numeros_aleatorios[i] << " "; 
		}
    }
    cout<< "-----------------Resultados--------------------";
	mean_calculate(numeros_aleatorios,1);
	varianza_calculate(numeros_aleatorios,1);
	desviacion_estandar_muestral(numeros_aleatorios);
	mediana_muestral(numeros_aleatorios);
	moda_muestral(numeros_aleatorios);
	cout<< "--------------------Fin-------------------------"<<endl;
	return 0;
}
