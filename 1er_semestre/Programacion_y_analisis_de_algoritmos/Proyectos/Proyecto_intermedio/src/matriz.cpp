// Aquí se codifican las funciones descritas en la clase matriz.h.

#include "matriz.h" // importamos la clase matri.h
//----------------------------------Funciones generales---------------------------------------------
matriz::matriz(int filas, int columnas){ // construimos la matriz utilizando la memoria dinamica.
	m_filas=filas;
	m_columnas=columnas;

	df=new float *[m_filas];
	for(int i=0; i<m_filas; i++){
        df[i]=new float[m_columnas];
        }
	}

matriz::~matriz(){           // liberamos la memoria dinamica.
	for(int i=0; i<m_filas; i++){
        delete[] df[i];
	}
	delete[] df;
}

int matriz::numero_filas(){  // obtenemos el número de filas de una matriz.
    return m_filas;
}

int matriz::numero_columnas(){ // obtenemso el número de columnas de una matriz.
    return m_columnas;
}

void matriz::print(){           // imprimimos los elementos de la matriz.
    for (int i=0; i<m_filas; i++){
        for (int j=0; j<m_columnas; j++){
            cout << df[i][j]<< " ";
        }
        cout << endl;
    }
}

void matriz::generar_matriz_aleatoria(){   // asignamos valores aleatorias (0,99) a la matriz.
    for (int i=0; i<m_filas; i++){
        for (int j=0; j<m_columnas; j++){
            df[i][j]=rand()% 100;
        }
    }
    cout << "La matriz genera es:" << endl; // imprimimos la elementos de la matriz.
    print();
}

matriz* matriz::matriz_nula(int n) {    // creamos la matriz nula.
    matriz *aux_nula = new matriz(n,n);
    for (int i=0; i<n; i++){
        for (int j=0; j<n; j++){
        aux_nula->df[i][j]=NULL;
        }
    }
    aux_nula->print();  // imprimimos la matriz nula.
    return aux_nula;
}

matriz* matriz::operator=(const matriz &B) {  // Sobrecargamos el simbolo = para copiar una matriz.
    for (int i = 0; i<m_filas; i++) {
        for (int j = 0; j<m_columnas; j++) {
            df[i][j] = B.df[i][j];
        }
    }
    return this;
}


//----------------------------------Operaciones matriciales---------------------------------------------
// Función suma.
matriz* matriz::operator+(matriz& B){  // sumamos dos matrices.
    matriz *aux_suma= new matriz(m_filas, m_columnas); // inicializamos una matriz auxiliar
    if (B.numero_filas()!= m_filas|| B.numero_columnas()!=m_columnas) { // validamos el tamaño de las dos matrices.
        cout << "Las matrices tiene distinto tamaño, no es posible sumarlas." << endl;
        return matriz_nula(m_filas); // retornamos una matriz nula si no se puede realizar la operación.
    }
    for (int i=0; i<m_filas; ++i){ // sumamos los elementos.
        for (int j=0; j<m_columnas; ++j){
            aux_suma->df[i][j]=df[i][j]+B.df[i][j];
        }
    }
    aux_suma->print(); // imprimimos la matriz resultante.
    return aux_suma; // retornamos una nueva matriz.
}

// Función resta.
matriz* matriz::operator-(matriz& B){ // restamos dos matrices.
    matriz *aux_resta= new matriz(m_filas, m_columnas); // inicializamos una matriz auxiliar
    if (B.numero_filas()!= m_filas|| B.numero_columnas()!=m_columnas) { // validamos el tamaño de las dos matrices.
        cout << "Las matrices tiene distinto tamaño, no es posible restarlas." << endl;
        return matriz_nula(m_filas); // retornamos una matriz nula si no se puede realizar la operación.
    }

    for (int i=0; i<m_filas; ++i){ // restamos todos los elementos de las matrices.
        for (int j=0; j<m_columnas; ++j){
            aux_resta->df[i][j]=df[i][j]-B.df[i][j];
        }
    }
    aux_resta->print(); // imprimimos la matriz resultante.
    return aux_resta; // retornamos una nueva matriz.
}

// Función multiplicación
matriz* matriz::operator*(matriz& B){
    matriz *aux_multi= new matriz(m_filas, B.numero_columnas()); // inicializamos una matriz auxiliar
    if (B.numero_filas()!= m_columnas) { // validamos el tamaño de las dos matrices.
        cout << "No se puede realizar la multiplicación, ya que el numero de" << endl;
        cout << "filas de la primera matriz no es igual a el numero de columnas" << endl;
        cout << "de la segunda matriz" << endl;
        return matriz_nula(m_filas); // retornamos una matriz nula si no se puede realizar la operación.
    }
    for (int i = 0; i<m_filas; ++i) { // realizamos la multiplicación matricial.
        for (int j = 0; j<B.numero_columnas(); ++j) {
            for (int k = 0; k<B.numero_filas(); ++k) {
                aux_multi->df[i][j] += (df[i][k] * B.df[k][j]);
            }
        }
    }
    aux_multi->print(); // imprimimos la matriz resultante.
    return aux_multi; // retornamos una nueva matriz.
}

// Función tranpuesta.
matriz* matriz::tranpuesta(){
    matriz *aux_tranpu = new matriz(m_columnas, m_filas); // inicializamos una matriz auxiliar
    for (int i=0; i<m_filas; ++i) { // transponemos los elementos de la matriz.
        for (int j=0; j<m_columnas; ++j) {
            aux_tranpu->df[j][i] = df[i][j];
        }
    }
    aux_tranpu->print(); // imprimimos la matriz resultante.
    return aux_tranpu; // retornamos una nueva matriz.
}

// Función para generar una matriz identidad (se utiliza en la eliminacion gaussiana).
matriz* matriz::matriz_identidad(int n){
    matriz *aux_identidad = new matriz(n, n); // inicializamos una matriz
    for (int i = 0; i < n; ++i) { // creamos una matriz con unos en la diagonal y ceros en los demas.
        for (int j = 0; j < n; ++j) {
            if (i == j) {
                aux_identidad->df[i][j] = 1;
            }
            else {
                aux_identidad->df[i][j] = 0;
            }
        }
    }
    return aux_identidad; // retornamos la matriz identidad.
}

// Validación de la existencia del pivote en una columna dada (se utiliza en la eliminacion gauss-jordan.
int matriz::existencia_pivote(int pivote){
    for (int h=pivote; h<m_filas; ++h){
        if (df[h][pivote]!=0){ // comparamos todos los elementos de la columna para ver si todos son ceros.
            return h; // retornamos el pivote
        }
    }
    return -1; // retornamos -1 si no hay pivotes.
}

// Intercambiamos pivotes.
int matriz::intercambia_pivote(int m, int k){
    matriz aux_intercambio(1, m_columnas); // inicializamos una matriz de tamaño 1xm.
    if (m==k){ // si coinciden el número de columnas y el pivote terminamos.
    return 0; // retornamos 0.
    }
    else{
        for(int i=0; i<m_columnas; ++i){ // copiamos los elementos de la fila k
            aux_intercambio.df[1][i]=df[k][i];
        }
        for(int i=0; i<m_columnas; ++i){ // asignamos los elementos de la fila k a la fila m
            df[k][i]=df[m][i];
            df[m][i]=aux_intercambio.df[1][i]; // asignamos los elemenos de la fila m a la fila k
        }
        return 0; // retornemos 0
    }
}

// Eliminación Gauss-Jordan.
matriz* matriz::eliminacion_gauss_jordan(){
    if (m_filas!= m_columnas) {  // validamos si la matriz es cuadrada.
        cout << "La matriz no es cuadrada, por lo que no se puede calcular la inversa." << endl;
        return matriz_nula(m_filas);  // retornamos la matriz nula
    }
    matriz* aux_identidad = new matriz(m_filas, m_filas);
    aux_identidad=matriz_identidad(m_filas);
    for (int i = 0; i < m_filas; ++i) {
        if (existencia_pivote(i)==-1){   // validamos la existencia del pivote.
            cout << "La matriz no tiene inversa."<< endl;
            return matriz_nula(m_filas);
        }
        else{      // intercambiamos el pivote de la matriz original y la matriz identidad.
            intercambia_pivote(i, existencia_pivote(i));
            aux_identidad->intercambia_pivote(i,existencia_pivote(i));
        }

        for (int j=(i+1); j<m_columnas; ++j){ // normalizamos la matriz
            df[i][j]=df[i][j]/df[i][i];
        }
        for (int j=0; j<m_columnas; ++j){ // normalizamos la matriz identidad.
            aux_identidad->df[i][j]=aux_identidad->df[i][j]/df[i][i];
        }
        df[i][i]=1; // asignamos 1 al pivote

        for (int k=(i+1); k<m_filas; ++k){
            for(int j=0; j<m_filas; ++j){ // aplicamos eliminación gauss-jordan a la matriz identidad.
                aux_identidad->df[k][j] += -aux_identidad->df[i][j]*df[k][i];
            }
            for(int j=(i+1); j<m_columnas; ++j){ // aplicamos eliminación gauss-jordan a la matriz original.
                df[k][j] += -df[i][j]*df[k][i];
            }
            df[k][i]=0; // actualizamos el pivote.
        }
    }

    // reducción hacia atras.
    for(int k=(m_columnas-1); k>-1; --k){
        for (int j=0; j<k; ++j){
            for (int h=0; h<m_columnas; ++h){ // realizamos la reducción hacia atras a la matriz U.
                aux_identidad->df[j][h]=aux_identidad->df[j][h]-aux_identidad->df[k][h]*df[j][k];
            }
            df[j][k]=0; // actualizamos los elementos.
        }
    }
    aux_identidad->print(); // imprimimos la inversa.
    return aux_identidad; // retornamos la inversa.
}

