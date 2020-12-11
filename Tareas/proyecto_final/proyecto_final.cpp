#include "funciones_matriciales.h" // cout, cin
#define HAVE_STRUCT_TIMESPEC

matriz A, B;
int main(){
    int nA, mA;

    char x, operacion, y, s; // definimos variables auxiliares menu

    cout << "Bienvenido al programa para operar matrices." << endl;
    cout << "Ingresa el tamano de la primera matriz (A), ejemplo, " << endl;
    cout << "para crear una matriz 5x7 ingresa 5 7 " << endl;
    cin >> nA >> mA;
    srand(time(NULL));

    A.m_columnas = mA;
    A.m_filas = nA;
    A = generar_matriz_aleatoria(A);

    cout << "¿Ingresaras otra matriz? Si ingresa 's' o No ingresa 'n'." << endl;
    cin >> s;
    if (s=='s'){
        int nB, mB;
        cout << "Ingresa el tamano de la segunda matriz (B), ejemplo, " << endl;
        cout << "para crear una matriz 5x7 ingresa 5 7 " << endl;
        cin >> nB >> mB; // generamos la matriz B.
        B.m_columnas = mB;
        B.m_filas = nB;
        B = generar_matriz_aleatoria(B);

        cout << "Haz creado la matriz A y B. Ahora ingresa la operacion a realizar,ejemplos:" << endl;
        cout << "A+B. |A-B. |A*B. |B*A. |Ai. |Bi. (Nota: con el punto)" << endl; // solicitamos la operación a realizar.
        cin >> x >> operacion >> y;
        if (x=='A' && y=='B'){ // Comparamos lo ingresado para ejecutar la función.
            ejecutar(A, operacion, B);
            liberarmemoria(B);
            return 0;
        }
        else if (x=='B' && y=='A'){
            ejecutar(B, operacion, A);
            liberarmemoria(B);
            return 0;
        }
        else if (x=='A' && y=='A'){
            ejecutar(A, operacion, A);
            liberarmemoria(B);
            return 0;
         }
        else if (x=='B' && y=='B'){
            ejecutar(B, operacion, B);
            liberarmemoria(A);
            return 0;
        }
        else if (x=='A' && operacion=='i' && y=='.'){
            ejecutar(A, operacion, A);
            liberarmemoria(B);
            return 0;
        }
        else if (x=='B' && operacion=='i' && y=='.'){
            ejecutar(B, operacion, B);
            liberarmemoria(A);
            return 0;
        }
        else{
        cout << "Ingresate mal la operacion a realizar. Saliendo..." << endl;
            }
        liberarmemoria(A);
        liberarmemoria(B);

    }
    else if (s=='n'){
        cout << "Haz creado la matriz A. Ahora ingresa la operacion a realizar,ejemplos:" << endl;
        cout << "A+A. |A-A. |A*A. |Ai. (Nota: con el punto)" << endl; // solicitamos la operación a realizar.
        cin >> x >> operacion >> y; // omparamos lo ingresado para ejecutar la función.
        if (x=='A' && y=='A'){  // ejecutamos la operación ingresada.
            ejecutar(A, operacion, A);
            return 0;
        }
        else if (x=='A' && operacion=='i' && y=='.'){
            ejecutar(A, operacion, A);
            return 0;
        }
        else { // error al ingresar lo solicitado.
        cout << "Ingresate mal la operacion a realizar. Saliendo..." << endl;
            }
        liberarmemoria(A);
        }
    else {
        cout << "Ingresaste mal la respuesta solo se admite s o n. Saliendo..." << endl;
        return 0;
    }


    cout << "-----------------------------------------------------------" << endl;
    cout << "Saliendo del programa..." << endl;
    return 0;
}


