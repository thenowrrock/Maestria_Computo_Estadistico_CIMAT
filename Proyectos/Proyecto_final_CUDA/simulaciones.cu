#include "funciones_simulacion.h"  // archivo auxiliar con las funciones a utilizar.

int main(){
	clock_t t1, t2; // variables para el tiempo en CPU
    float tiempo_cpu, tiempo_gpu; // variables para el tiempo en GPU

    matriz h_A, h_B, h_resultado, h_resultado_secuencia; // variables tipo matriz que se ocupara en el host
    matriz dev_A, dev_B, dev_resultado; // variables tipo matriz que se ocupara en el device
	int mA, nA, mB, nB; // variables enteras para los tamanos de las matrices.
    
    // Solicitud de los tamanos de la matriz A.
    cout<<"Bienvenido al programa para operar matrices."<<endl; 
    cout<<"Ingresa el tamano de la primera matriz (A), ejemplo, " << endl;
    cout<<"para crear una matriz 5x7 ingresa 5 7 "<<endl;
    cin >> nA >> mA;
	
	// Inicializamos la matriz A en host.
	h_A.n = nA; // asignamos los tamanos a la struct matriz.  
	h_A.m = mA;
    h_A.df = new int [nA*mA]; // apartamos la memoria dinamica.
	h_A = generar_matriz_aleatoria(h_A); // generamos numeros aleatorias para la matriz.
	
	// Solicitud de los tamanos de la matriz B.
	cout<<"Ingresa el tamano de la segunda matriz (B), ejemplo, "<<endl;  
    cout << "para crear una matriz 5x7 ingresa 5 7 " << endl;
    cin >> nB >> mB; // generamos la matriz B.
    
    // Inicializamos la matriz B en host.
    h_B.n = nB; // asignamos los tamanos a la struct matriz. 
    h_B.m = mB;
    h_B.df = new int [nB*mB]; // apartamos la memoria dinamica.
    h_B = generar_matriz_aleatoria(h_B); // generamos numeros aleatorias para la matriz.
    
    dev_A.n = h_A.n; // asignamos los tamanos a la struct matriz A que estara en device
    dev_A.m = h_A.m;     
    cudaMalloc(&dev_A.df, nA*mA*sizeof(int)); // asignacion de memoria lineal en device
    cudaMemcpy(dev_A.df, h_A.df, nA*mA*sizeof(int), cudaMemcpyHostToDevice); // copiamos los datos del host al device 

    dev_B.n = h_B.n; // asignamos los tamanos a la struct matriz B que estara en device
    dev_B.m = h_B.m;
    cudaMalloc(&dev_B.df, nB*mB*sizeof(int)); // asignacion de memoria lineal en device
	cudaMemcpy(dev_B.df, h_B.df, nB*mB*sizeof(int), cudaMemcpyHostToDevice); // copiamos los datos del host al device

    char x, operacion, y; // variables para realizar operaciones
    cout << "Haz creado la matriz A y B. Ahora ingresa la operacion a realizar,ejemplos:" << endl;
    cout << "A+B. |A-B. |A*B. |B*A. (Nota: con el punto)" << endl; // solicitamos la operacion
    cin >> x >> operacion >> y;


    cudaEvent_t start, stop; // medimos el tiempo en GPU, considerando la recomendacion la guía para CUDA
                            // ver bibliografia del reporte.
	cudaEventCreate(&start); // inicializamos lo eventos
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0); // inicio del contador

    if (x=='A' && y=='B' && operacion=='*'){
        h_resultado.n = dev_A.n;  // asignamos los tamanos a la struct matriz para los resultados de la multiplicacion en host
        h_resultado.m = dev_B.m;
        h_resultado.df = new int [dev_A.n*dev_B.m]; // apartamos la memoria dinamica para los resultados.
        
        dev_resultado.n = h_resultado.n; // asignamos los tamanos a la struct matriz para los resultados de la multiplicacion en device
        dev_resultado.m = h_resultado.m;
        cudaMalloc(&dev_resultado.df, dev_A.n*dev_B.m*sizeof(int)); // asignacion de memoria lineal en device
    }
    else if (x=='B' && y=='A' && operacion=='*'){
        h_resultado.n = dev_B.n; // asignamos los tamanos a la struct matriz para los resultados de la multiplicacion en host
        h_resultado.m = dev_A.m;
        h_resultado.df = new int [dev_B.n*dev_A.m]; // apartamos la memoria dinamica para los resultados.
        
        dev_resultado.n = h_resultado.n; // asignamos los tamanos a la struct matriz para los resultados de la multiplicacion en device
        dev_resultado.m = h_resultado.m;
        cudaMalloc(&dev_resultado.df, dev_B.n*dev_A.m*sizeof(int)); // asignacion de memoria lineal en device
    }
    else{
        h_resultado.n = dev_A.n; // asignamos los tamanos a la struct matriz para los resultados de la suma/resta en host
        h_resultado.m = dev_A.m;
        h_resultado.df = new int [dev_A.n*dev_A.m]; // apartamos la memoria dinamica para los resultados.
        
        dev_resultado.n = h_resultado.n; // asignamos los tamanos a la struct matriz para los resultados de la suma/resta en device
        dev_resultado.m = h_resultado.m;
        cudaMalloc(&dev_resultado.df, dev_A.n*dev_A.m*sizeof(int)); // asignacion de memoria lineal en device
    }
    
    ejecutar_operacion(dev_A, dev_B, operacion, dev_resultado, h_resultado, x, y); // ejecutamos la operacion
    
    cudaEventRecord(stop, 0); // detenemos el contador de tiempo

	cudaEventSynchronize(stop); // esperamos a que todos los hilos terminen
	cudaEventElapsedTime(&tiempo_gpu, start, stop); // tiempo de ejecucion
	cudaEventDestroy(start);  // eliminamos los eventos.
	cudaEventDestroy(stop);
	
	t1 = clock(); 

    //---------------Secuencia suma y resta
	// h_resultado_secuencia.n = h_A.n; // asignamos los tamanos a la struct matriz. 
    // h_resultado_secuencia.m = h_A.m;
    // h_resultado_secuencia.df = new int [h_A.n*h_A.m]; // apartamos la memoria dinamica.
    
    // suma_matriz_sec(h_A, h_B, h_resultado_secuencia);
    // resta_matriz_sec(h_A, h_B, h_resultado_secuencia);
    
    // --------------Secuencia multiplicacion
    h_resultado_secuencia.n = h_A.n; // asignamos los tamanos a la struct matriz. 
    h_resultado_secuencia.m = h_B.m;
    h_resultado_secuencia.df = new int [h_A.n*h_B.m]; // apartamos la memoria dinamica.
    
    multiplicacion_matriz_sec(h_A, h_B, h_resultado_secuencia);
    
	t2 = clock();
    tiempo_cpu = (double(t2 - t1) )/ double(CLOCKS_PER_SEC); //tiempo de ejecucion en CPU

    cout<<"\nCPU: "<<tiempo_cpu<<", GPU: "<<tiempo_gpu<<endl;

	return 0;
}