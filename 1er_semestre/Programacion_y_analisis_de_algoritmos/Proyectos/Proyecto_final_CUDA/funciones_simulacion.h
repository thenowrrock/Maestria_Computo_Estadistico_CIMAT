#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cmath>

using namespace std; // cout, endl, 

//----------------------------------Estructura-------------------------------------//
// estructura para una matriz de tamano de n x m.
typedef struct {
 int n; // renglones
 int m; // columnas
 int* df; // datos
} matriz;

//--------------------------Funciones--en--GPU----------------------------------------------//
// Suma matricial de device
__global__ void suma_matriz(matriz A, matriz B, matriz A_B){
    int j = blockIdx.x * blockDim.x + threadIdx.x; // coordenada x del hilo en el block
    int i = blockIdx.y * blockDim.y + threadIdx.y; // coordenada x del hilo en el block

    A_B.df[j + i * A.n] = A.df[j + i * A.n] + B.df[j + i * A.n]; // sumamos los elementos que esten en la misma posicion
}

// Resta matricial de device
__global__ void resta_matriz(matriz A, matriz B, matriz A_B){
    int j = blockIdx.x * blockDim.x + threadIdx.x; // coordenada x del hilo en el block
    int i = blockIdx.y * blockDim.y + threadIdx.y; // coordenada y del hilo en el block

    A_B.df[j + i * A.n] = A.df[j + i * A.n] - B.df[j + i * A.n]; // restamos los elementos que esten en la misma posicion
}

// Multiplicacion matricial de device
__global__ void multiplicacion_matriz(matriz A, matriz B, matriz C) {
    int suma = 0; // variable auxiliar
    int j = blockIdx.x * blockDim.x + threadIdx.x; // coordenada x del hilo en el block
    int i = blockIdx.y * blockDim.y + threadIdx.y; // coordenada y del hilo en el block
    
    for (int k = 0; k < A.n; ++k) // cada hilo se encarga de una fila de A por una columna de B.
        suma += A.df[k+i * A.n] * B.df[j + k * B.n];
 
    C.df[j+ i * C.n] = suma;
}
//------------------------Funciones_matrices_________________________________//
// Generar matriz aleatoria.
matriz generar_matriz_aleatoria(matriz A){
    for (int i=0; i< A.n; i++){
        for (int j=0; j< A.m; j++){
            A.df[i+j*A.n]=rand()% 100;
        }
    }
   return A; 
}

// Imprimir matriz.
void imprimir_matriz(matriz A){  // imprimimos los elementos de la matriz.
    for (int i=0; i<A.n; i++){
        for (int j=0; j<A.m; j++){
            cout << A.df[i+j*A.n]<< " ";
        }
        cout << endl;
    }
}

//--------------------------------Validacion de tamanos matriciales------------------------------------------//
// Suma/resta de matrices
int validacion_tamano_suma_resta(matriz A, matriz B){ //tamanos iguales
    if ((A.m==B.m)&& (A.n==B.n)){
        return 1;
    }
    else{
        cout << "Los tamanos de las matrices no son adecuados para la operacion" << endl;
        cout << "-----------------------------------------------------------" << endl;
        cout << "Saliendo del programa..." << endl;
        return 0;
    }
}

// Multiplicacion matricial
int validacion_tamano_multiplicacion(matriz A, matriz B){
    if (A.m==B.n){ // numero de columnas de A tiene que ser igual al numero de filas de B
        return 1;
    }
    else{
        cout << "Los tamanos de las matrices no son adecuados para realizar la multiplicacion." << endl;
        cout << "-----------------------------------------------------------" << endl;
        cout << "Saliendo del programa..." << endl;
        return 0;
    }
}

// -----------------------------Ejecutar la funcion seleccionada en la GPU-------------------------------------//
// Esta funcion se encarga de ejecutar la funcion seleccionada en el menu del programa en la GPU.
void ejecutar_operacion(matriz dev_A, matriz dev_B, char operacion, matriz dev_resultado, matriz h_resultado, char x, char y){
    // configuracion de ejecucion
    int tamresultado = dev_resultado.m*dev_resultado.n*sizeof(float);
    int BLOCK_SIZE = dev_resultado.n; // numero de hilos por 'renglon'
    int BLOCK_SIZE_2 = dev_resultado.m; // numero de hilos por 'columna'
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE_2); // bloque con los hilos
    dim3 dimGrid(dev_resultado.n/dimBlock.x, dev_resultado.m/dimBlock.y); // rejilla
    
    if (x=='A' && y=='B' && operacion=='+'){ // Comparamos lo ingresado para ejecutar la funcion.
        if(validacion_tamano_suma_resta(dev_A, dev_B)==1){ // comprobamos que se pueda ejecutar la funcion suma
            suma_matriz<<<dimGrid,dimBlock>>>(dev_A, dev_B, dev_resultado);
            cudaMemcpy(h_resultado.df, dev_resultado.df, tamresultado, cudaMemcpyDeviceToHost);

            delete h_resultado.df; // liberamos memoria en host
    
    	    cudaFree(dev_A.df); // liberamos memoria en device
            cudaFree(dev_B.df); // liberamos memoria en device
            cudaFree(dev_resultado.df); // liberamos memoria en device
        }
    }
    else if (x=='B' && y=='A' && operacion=='+'){ // comentarios parecidos a lo anterior
        if(validacion_tamano_suma_resta(dev_B, dev_A)==1){
            suma_matriz<<<dimGrid,dimBlock>>>(dev_B, dev_A, dev_resultado);
            cudaMemcpy(h_resultado.df, dev_resultado.df, tamresultado, cudaMemcpyDeviceToHost);

            delete h_resultado.df;
    
    	    cudaFree(dev_A.df);
            cudaFree(dev_B.df);
            cudaFree(dev_resultado.df);
        }
    }
    else if (x=='A' && y=='B' && operacion=='-'){ // comparamos lo ingresado para ejecutar la funcion.
        if(validacion_tamano_suma_resta(dev_A, dev_B)==1){ // comprobamos que se pueda ejecutar la funcion suma
            resta_matriz<<<dimGrid,dimBlock>>>(dev_A, dev_B, dev_resultado);
            cudaMemcpy(h_resultado.df, dev_resultado.df, tamresultado, cudaMemcpyDeviceToHost);

            delete h_resultado.df; // liberamos memoria en host
    
    	    cudaFree(dev_A.df); // liberamos memoria en device
            cudaFree(dev_B.df); // liberamos memoria en device
            cudaFree(dev_resultado.df); // liberamos memoria en device
        }
     }
    else if (x=='B' && y=='A' && operacion=='-'){ // comentarios parecidos a lo anterior
        if(validacion_tamano_suma_resta(dev_B, dev_A)==1){
            resta_matriz<<<dimGrid,dimBlock>>>(dev_B, dev_A, dev_resultado);
            cudaMemcpy(h_resultado.df, dev_resultado.df, tamresultado, cudaMemcpyDeviceToHost);

            delete h_resultado.df;
    
    	    cudaFree(dev_A.df);
            cudaFree(dev_B.df);
            cudaFree(dev_resultado.df);
        }
    }
    else if (x=='A' && y=='B' && operacion=='*'){ // comentarios parecidos a los anteriores pero para la multiplicacion
        if(validacion_tamano_multiplicacion(dev_A, dev_B)==1){
            multiplicacion_matriz<<<dimGrid,dimBlock>>>(dev_B, dev_A, dev_resultado);
            cudaMemcpy(h_resultado.df, dev_resultado.df, tamresultado, cudaMemcpyDeviceToHost);
            delete h_resultado.df;
    
    	    cudaFree(dev_A.df);
            cudaFree(dev_B.df);
            cudaFree(dev_resultado.df);
        }
    }
    else if (x=='B' && y=='A' && operacion=='*'){ // comentarios parecidos a los anteriores pero para la multiplicacion
        if(validacion_tamano_multiplicacion(dev_B, dev_A)==1){
            multiplicacion_matriz<<<dimGrid,dimBlock>>>(dev_A, dev_B, dev_resultado);
            cudaMemcpy(h_resultado.df, dev_resultado.df, tamresultado, cudaMemcpyDeviceToHost);
            delete h_resultado.df;
    
    	    cudaFree(dev_A.df);
            cudaFree(dev_B.df);
            cudaFree(dev_resultado.df);
        }
    }
    else{
    cout << "Ingresate mal la operacion a realizar. Saliendo..." << endl;
	    cudaFree(dev_A.df);
        cudaFree(dev_B.df);
        }
}

//------------------------------------------Funciones Secuenciales----------------------------------------//
// Suma matricial
void suma_matriz_sec(matriz mat_1, matriz mat_2, matriz resultado){ 
    for (int i=0; i< resultado.n; i++){
        for (int j = 0; j<resultado.m; j++) {
            resultado.df[i+j*resultado.n] = mat_1.df[i+j*resultado.n]+mat_2.df[i+j*resultado.n];
        }
    }
}

// Resta matricial
void resta_matriz_sec(matriz mat_1, matriz mat_2, matriz resultado){  // restamos dos matrices.
    for (int i=0; i< resultado.n; i++){
        for (int j = 0; j<resultado.m; j++) {
            resultado.df[i+j*resultado.n] = mat_1.df[i+j*resultado.n]-mat_2.df[i+j*resultado.n];
        }
    }
}

// Multiplicacion matricial
void multiplicacion_matriz_sec(matriz mat_1, matriz mat_2, matriz resultado){  // multiplicamos dos matrices.
    for(int i = 0; i < mat_1.n; ++i) {
        for(int j = 0; j <resultado.m; ++j) {
            long int sum = 0.0;
            for(int k = 0; k < resultado.m; ++k) {
                sum = sum + (mat_1.df[k+i*mat_1.n] * mat_2.df[j+k*mat_2.n]);
            }
        resultado.df[j+i*resultado.n] = sum;
        }
    }
}