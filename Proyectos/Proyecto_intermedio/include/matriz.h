//---------------------------------Documentación-----------------------------------------------
//------------------------------- Clase matriz.h-----------------------------------------------
// Esta clase tiene como objetivo la manipulación de dos matatrices en C++. Especificamente sir-
// para generar 1 o dos matrices con números aleatorios (1,100), y después permite manipularlas
// para obterner su suma, resta, multiplicación, inversa, tranpuesta. Antes de realizar la pro-
// gramación valida los tamaños de las matrices, prueba si tiene inversa (si es cuadrada y tie-
// ne n pivotes). Se utilizan los operadores +, -, *, t. (tranpuesta), i. (inversa). Por ejem-
// plo: Sea A y B dos matrices de tamaño 2x2 entonces en la terminal se agrega:
// ----A+B   (suma de matrices)
// ----A-B   (resta de matrices)
// ----A*B   (multiplicacioens de matrices)
// ----At.   (tranpuesta de matrices)
// ----Ai.   (inversa de matrices)
// Para calcular la inversa se utiliza eliminación Gauss-Jordan.
// Enrique Santibáñez Cortés.

#pragma once
#include <stdlib.h> // cout, cin
#include <iostream>

using namespace std; //rand

class matriz{
	private:
        int m_filas, m_columnas; // numero de filas y columans de la matriz.
        float **df;              // elementos de la matriz.

	public:
        matriz(int filas, int columnas); // constructor de la matriz
        ~matriz();                       // destructor

        int numero_filas();  // obtenemos el numero de filas de la matriz
        int numero_columnas(); // obtenemos el numero de columnas de la matriz

        void generar_matriz_aleatoria(); // asignamos números aleatorios de la matriz
        void print();                    // imprimimos los valores de la matriz

        matriz* operator=(const matriz& B); // copiar una matriz

        matriz* operator+(matriz& B); // sumar dos matrices

        matriz* operator-(matriz& B); // restar dos matrices

        matriz* operator*(matriz& B); // multiplicar dos matrices

        matriz* tranpuesta(); // obtener la transpuesta de una matriz

        int existencia_pivote(int pivote); // validamos si existe un pivtoe en la columna pivote
        int intercambia_pivote(int i, int j); // ḿovemos el pivote
        matriz* matriz_identidad(int n); // matriz identidad de tamano n
        matriz* matriz_nula(int n);    // matriz nula de tamaño n
        matriz* eliminacion_gauss_jordan(); // eliminación gauss-jordan.
};
