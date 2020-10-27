// -------------------------------Documentacion--------------------------------------------------------------------
// Este codigo realiza las siguientes operaciones del álgebra de matrices:
//
// -----Suma
// -----Resta
// -----Multiplicación
// -----Transpuesta
// -----Inversa (Mediante el uso de eliminación Gauss-Jordan)
//
// Se considera las siguientes caracteristicass:
// -----1. Se debe pedir al usuario el tamaño de la o las matrices que se utilizarán para operarlas
// -----2. Las matrices se deben generar de manera aleatoria con números en el intervalo [0,99] (considerar
// -----   la instrucción srand para evitar que se generen matrices idénticas o matrices con muchos elementos
// -----   idénticos)
// -----3. Las matrices tendrán que ser manejadas mediante memoria dinámica
// -----4. Las matrices y su tamaño tendrán que ser guardadas en una estructura o en una clase
// -----5. Las operaciones deben generar una matriz extra donde se guarden y se retornen los resultados
// -----   correspondientes
// -----6. Las operaciones suma, resta y multiplicación, tienen que ser generadas considerando la sobrecarga
// -----   de los operadores +, -, y *, respectivamente.
// -----7. El código de cada operación deberá considerar las condiciones necesarias para poder ser realizadas
// -----   (tamaño adecuado, invertibilidad, etc.), y deberán regresar el valor NULL en caso que no se puedan
// -----   realizar; esto es, que la tabla con el contenido de la matriz, representada por un variable de tipo
// -----   apuntador doble, será igual a NULL.
// ------------------------------------------------------------------------------------------------------------------
// ----- Enrique Santibáñez Cortés.
// ----- Proyecto intermedio: Programación y análisis de algoritmos
// ------------------------------------------------------------------------------------------------------------------

#include "matriz.h" // llamamos la clase creada.
// función auxiliar para generar los resultados.
void ejecutar(matriz* A, char operacion, matriz* B){
    switch(operacion)
    {
        case '+':
            cout << "El resultado es:" << endl;
            *A + *B;
            break;
        case '-':
            cout << "El resultado es:" << endl;
            *A - *B;
            break;
        case '*':
            cout << "El resultado es:" << endl;
            *A* *B;
            break;
        case 't':
            cout << "El resultado es:" << endl;
            *A->tranpuesta();
            break;
        case 'i':
            cout << "El resultado es:" << endl;
            *A->eliminacion_gauss_jordan();
            break;
        case '0':
            cout << "Saliendo del programa..." << endl;
            break;
        default:
            cout << "Ingresaste mal la operacion." << endl;
            cout << "Saliendo del programa..." << endl;
    }
}


int main(){
int nA, mA; // inicializamos los tamaños de la matriz.
char x, operacion, y, s; // inicializamos los parametros auxiliares.

cout << "Bienvenido al programa para sumar matrices." << endl;
cout << "Ingresa el tamano de la primera matriz (A), ejemplo, " << endl;
cout << "para crear una matriz 5x7 ingresa 5 7 " << endl;
cin >> nA >> mA;
matriz* A = new matriz(nA, mA);
A->generar_matriz_aleatoria();

cout << "\n ¿Ingresaras otra matriz? Si ingresa 's' o No ingresa 'n'." << endl;
cin >> s;
if (s=='s'){
    int nB, mB;
    cout << "Ingresa el tamano de la segunda matriz (B), ejemplo, " << endl;
    cout << "para crear una matriz 5x7 ingresa 5 7 " << endl;
    cin >> nB >> mB; // generamos la matriz B.
    matriz*  B= new matriz(nB, mB);
    B->generar_matriz_aleatoria();

    cout << "\n Haz creado la matriz A y B. Ahora ingresa la operacion a realizar,ejemplos:" << endl;
    cout << "A+B. |A-B. |A*B. |At. |Bt. |Ai. |Ai. (Nota: con el punto)" << endl; // solicitamos la operación a realizar.
    cin >> x >> operacion >> y;
    if (x=='A' && y=='B'){ // Comparamos lo ingresado para ejecutar la función.
        ejecutar(A, operacion, B);
    }
    else if (x=='B' && y=='A'){
        ejecutar(B, operacion, A);
    }
    else if (x=='A' && y=='A'){
        ejecutar(A, operacion, A);
     }
    else if (x=='B' && y=='B'){
        ejecutar(B, operacion, B);
    }
    else if (x=='A' && operacion=='t' && y=='.'){
        ejecutar(A, operacion, A);
    }
    else if (x=='A' && operacion=='i' && y=='.'){
        ejecutar(A, operacion, A);
    }
    else if (x=='B' && operacion=='t' && y=='.'){
        ejecutar(B, operacion, B);
    }
    else if (x=='B' && operacion=='i' && y=='.'){
        ejecutar(B, operacion, B);
    }
    else{
    cout << "Ingresate mal la operacion a realizar. Saliendo..." << endl;
        }
    delete A;
    delete B;
    }
else if (s=='n'){
    cout << "\n Haz creado la matriz A. Ahora ingresa la operacion a realizar,ejemplos:" << endl;
    cout << "A+A. |A-A.|At.|Ai. (Nota: con el punto)" << endl; // solicitamos la operación a realizar.
    cin >> x >> operacion >> y; // omparamos lo ingresado para ejecutar la función.
    if (x=='A' && y=='A'){  // ejecutamos la operación ingresada.
        ejecutar(A, operacion, A);
     }
    else if (x=='A' && operacion=='t' && y=='.'){
        ejecutar(A, operacion, A);
    }
    else if (x=='A' && operacion=='i' && y=='.'){
        ejecutar(A, operacion, A);
    }
    else {
    cout << "Ingresate mal la operacion a realizar. Saliendo..." << endl;
        }

    delete A;
    }
else {
    cout << "Ingresaste mal la respuesta solo se admite s o n. Saliendo..." << endl;
    return 0;
}
cout << "-----------------------------------------------------------" << endl;
cout << "Saliendo del programa..." << endl;
return 0;
}


