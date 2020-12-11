#include "funciones_matriciales.h" // cout, cin
#define HAVE_STRUCT_TIMESPEC

matriz A, B, resultado, aux_identidad;
int NTHREADS = 4;


int ejecutar_suma(matriz A, matriz B){
    int nA = A.m_columnas;
    resultado.m_columnas = A.m_columnas;
    resultado.m_filas = A.m_filas;
    resultado = iniciar_matriz(resultado);

    pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
    Argumentos *args = new Argumentos[NTHREADS];
    int subint = floor(nA/NTHREADS);  // limites para cada hilo

        for(int i=0; i<NTHREADS; i++){
            if(i==NTHREADS-1){       // limites para cada hilo
                args[i].sup = nA;
                args[i].inf = subint*i;
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
            } 
            else{
                args[i].inf = subint*i;
                args[i].sup = subint*(i+1);
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
                }
                pthread_attr_t attr;     // asignamos las tareas a los hilos.
                pthread_attr_init(&attr);
                pthread_create(&thr[i], &attr, suma_matriz_hilo, &args[i]);
                }

                for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
                    pthread_join(thr[i], NULL);
                }
                    
                cout << "La matriz A es:" << endl;
                imprimir_matriz(A);
                cout << "La matriz B es:" << endl;
                imprimir_matriz(B);
                cout << "La suma de matrices es" << endl;
                imprimir_matriz(resultado);
                delete thr;  // limpiamos memoria.
                delete args;
                liberarmemoria(A);
                liberarmemoria(resultado);
            return 0;
}


int ejecutar_resta(matriz A, matriz B){
    int nA = A.m_columnas;
    resultado.m_columnas = A.m_columnas;
    resultado.m_filas = A.m_filas;
    resultado = iniciar_matriz(resultado);

    pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
    Argumentos *args = new Argumentos[NTHREADS];
    int subint = floor(nA/NTHREADS);  // limites para cada hilo

        for(int i=0; i<NTHREADS; i++){
            if(i==NTHREADS-1){       // limites para cada hilo
                args[i].sup = nA;
                args[i].inf = subint*i;
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
            } 
            else{
                args[i].inf = subint*i;
                args[i].sup = subint*(i+1);
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
                }
                pthread_attr_t attr;     // asignamos las tareas a los hilos.
                pthread_attr_init(&attr);
                pthread_create(&thr[i], &attr, resta_matriz_hilo, &args[i]);
                }

                for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
                    pthread_join(thr[i], NULL);
                }
                    
                cout << "La matriz A es:" << endl;
                imprimir_matriz(A);
                cout << "La matriz B es:" << endl;
                imprimir_matriz(B);
                cout << "La resta de matrices es" << endl;
                imprimir_matriz(resultado);
                delete thr;  // limpiamos memoria.
                delete args;
                liberarmemoria(A);
                liberarmemoria(resultado);
            return 0;
}

int ejecutar_multiplicacion(matriz A, matriz B){
    int nA = A.m_filas;
    resultado.m_columnas = B.m_columnas;
    resultado.m_filas = A.m_filas;
    resultado = iniciar_matriz(resultado);

    pthread_t *thr = new pthread_t[NTHREADS];  // inicializamsos los hilos
    Argumentos *args = new Argumentos[NTHREADS];
    int subint = floor(nA/NTHREADS);  // limites para cada hilo

        for(int i=0; i<NTHREADS; i++){
            if(i==NTHREADS-1){       // limites para cada hilo
                args[i].sup = nA;
                args[i].inf = subint*i;
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
            } 
            else{
                args[i].inf = subint*i;
                args[i].sup = subint*(i+1);
                args[i].mat_1 = A;
                args[i].mat_2 = B;
                args[i].resultado = resultado;
                }
                pthread_attr_t attr;     // asignamos las tareas a los hilos.
                pthread_attr_init(&attr);
                pthread_create(&thr[i], &attr, multiplicacion_matriz_hilo, &args[i]);
                }

                for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
                    pthread_join(thr[i], NULL);
                }
                    
                cout << "La matriz A es:" << endl;
                imprimir_matriz(A);
                cout << "La matriz B es:" << endl;
                imprimir_matriz(B);
                cout << "La multiplicacion resultante es" << endl;
                imprimir_matriz(resultado);
                delete thr;  // limpiamos memoria.
                delete args;
                liberarmemoria(A);
                liberarmemoria(resultado);
            return 0;
}


int ejecutar_inversa(matriz A){
    int nA = A.m_columnas;
    aux_identidad = generar_matriz_identidad(A.m_filas);
    pthread_t *threads = NULL;
    threads = (pthread_t*)malloc(NTHREADS * sizeof(pthread_t));

    argumentos_inversa *args = NULL;
    args = (argumentos_inversa*)malloc(NTHREADS * sizeof(argumentos_inversa));

    int subint = floor(nA/NTHREADS);  // limites para cada hilo

    for(int i=0; i<NTHREADS; i++){
        args[i].mat = A;
        args[i].aux_identidad = aux_identidad;
        args[i].rank = i;
        args[i].NTHREADS = NTHREADS;

        pthread_create(threads+1, 0, inversa_p , args+i);
        }   

    for(int i=0;i<NTHREADS;i++){ // espera de cada hilo.
        pthread_join(threads[i], 0);
    }

    imprimir_matriz(aux_identidad);
    liberarmemoria(A);
    liberarmemoria(aux_identidad);

    delete threads;  // limpiamos memoria.
    delete args;
    return 1;

}

int ejecutar(matriz A, char operacion, matriz B){
    switch(operacion)
    {
        case '+':
            cout << "El resultado es:" << endl;
            if (validacion_tamano_suma_resta(A, B)==1){
            ejecutar_suma(A, B);
            }
            else{
                return 0;
            }
            break;
        case '-':
            cout << "El resultado es:" << endl;
            if (validacion_tamano_suma_resta(A, B)==1){
            ejecutar_resta(A, B);
            }
            else{
                return 0;
            }
            break;
        case '*':
            cout << "El resultado es:" << endl;
            if (validacion_tamano_multiplicacion(A, B)==1){
            ejecutar_multiplicacion(A, B);
            }
            else{
                return 0;
            }            
            break;
        case 'i':
            if (validacion_tamano_inversa(A.m_filas, A.m_columnas)==1){
                ejecutar_inversa(A);
            }
            else{
                return 0;
            }
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
    int nA, mA;

    char x, operacion, y, s; // definimos el número de hilos
    double elapsed;

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
        else {
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


