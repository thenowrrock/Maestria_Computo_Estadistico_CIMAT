from itertools import permutations, combinations
import numpy as np
import pandas as pd

def load_parametres(path_data):
    """
    Esta función lee el archivo con los datos del problema a optimizar. EL FORMATO DEL
    ARCHIVO DEBE DE SER IGUAL AL ARCHIVO  datos_EnriqueSantibanez.txt, es decir, 
    1. En el primer renglon debe de ir el numero de instancias a abrir.
    2. En el segundo renglon debe de el valor de alpha (parametro de aleatoriedad).
    3. Despues de los dos renglones debe de estar los costos de clientes y el costo
       de localizacion de las instancias en la última columna.
       
    Args:
        path_data - direccion del archivo.

    Returns:
        p - número de instalaciones que se deben abrir
        alpha - parametro de aleatoriedad
        c_ij - matriz costo de asignación del cliente j a la instalación i, ∀i∈I, j∈J
        f_i - vector costo de localizar la instalación i, ∀i∈I
        intancias - vector de instancias del problema.
    """
    datos = pd.read_table(path_data, nrows=1)
    p = int(datos.columns[0][2:])
    alpha = float(datos.loc[0]["p 4"][6:])
    
    datos = pd.read_table(path_data, skiprows=2, header=None)
    c_ij = datos[datos.columns[:-1]].to_numpy()
    f_i = datos[datos.columns[-1]].to_numpy()
    instacias = [i for i in range(0,c_ij.shape[0])]
    return p, alpha, c_ij, f_i, instacias


def solution_opti(y_aux, c_ij, f_i, combination=0):
    """
    Esta función encuentra la distribución de clientes a asignar a partir de un
    conjunto de instancias a abrir. Esta funcion se puede considerar como la 
    función greedy.

    Args:
        y_aux - direccion del archivo.
        c_ij - matriz costo de asignación
        f_i - vector costo de localizar
        combination - parametro para imprimir las combinaciones optimas

    Returns:
        costo_optimo - costo de asignación y el costo de apertura de la combina
                        cion ingresada. 
        A - matriz de combinaciones optimas
    """
    if len(y_aux)==1: # para la primera iteracion solo sumamos los costos de todos 
                      # los clientes en una instancia mas el costo de apertura.
        return np.sum(np.sum(c_ij[y_aux])+f_i[y_aux])
    else:
        if combination==0: # para las siguientes iteraciones asignamos los clientes
                           # considerando el costo minimo de las instalaciones mas
                           # el costo de apertura.
            return np.sum(np.sum(np.min(c_ij[y_aux], axis=0))+np.sum(f_i[y_aux]))
        else:
            clien_min = np.argmin(c_ij[y_aux], axis=0) # buscamos las asignaciones 
            A = np.zeros([len(y_aux),c_ij.shape[1]])   # optimas, considerando el 
            for i in range(c_ij.shape[1]):             # comentario de arriba.
                A[clien_min[i],i]=1
            return np.sum(np.sum(np.min(c_ij[y_aux], axis=0))+np.sum(f_i[y_aux])), A
    
def semi_greedy(y, c_ij, f_i, p_k, alpha):
    """
    Esta función aplica la metodologia del algoritmo semi-greedy:
    Repetir hasta que la solución esté construida:
        1. Para cada elemento candidato:
            - Aplicar una función greedy.
            - Ordenar los elementos de acuerdo a los valores de la función greedy.
        4. Crear una lista restringida de candidatos.
        5. Seleccionar un elemento de la lista de manera aleatoria.
        6. Añadir el elemento seleccionado a la solución.

    Args:
        y - lista de candidatos a elegir
        c_ij - matriz costo de asignación
        f_i - vector costo de localizar
        p_k - numpero de elementos a elegir
        alpha - parametro de aleatoriedad

    Returns:
        y_solution - instancias a abrir
        cost_final - costo de asignación y el costo de apertura de la combina
                        cion ingresada. 
        A_opti - matriz de combinaciones optimas
    """
    y_solution = [] # inicializamos el vector solucion
    n = c_ij.shape[1] # numero de clientes 
    while len(y_solution)<p_k: # deterner hasta tener el número de instancias abiertas
        costos = [] # inicializamos el vector de costos
        for inst in y: # a cada instacia aplicamos la función greedy.
            y_aux = y_solution.copy()
            y_aux.append(inst)
            cost_optimo = solution_opti(y_aux, c_ij, f_i)
            costos.append(cost_optimo)
         
        c_max = np.max(costos) # calculamos el minimo y maximo de nuestros costos
        c_min = np.min(costos)
        lim_sup = c_min+alpha*(c_max-c_min) 

        RL = np.concatenate(np.argwhere(costos <= lim_sup)) # creamos la lista restringida
        rand = np.random.choice(RL, 1)                      # de candidatos y seleccionamos
        y_solution.append(y[rand[0]])                       # uno al azar. Lo agregamos al 
        y.remove(y[rand[0]])                                # conjunto solucion y actualizamos
                                                            # nuestra lista de candidatos.
    
    cost_final, A_opti = solution_opti(y_solution, c_ij, f_i, combination=1)
    print("-----------------------------------------------------------------------------")
    print("-----------------------------------------------------------------------------")
    print("-----------------------------------------------------------------------------")
    print("-------------------------Solución construida---------------------------------")
    print("Las instalaciones que se tiene que abrir son", np.array(y_solution)+1)
    print("Las asignaciones de las instalaciones clientes son:")
    print(np.array(A_opti))
    print("-----------------------------------------------------------------------------")
    print("-----------------------------------------------------------------------------")
    print("-----------------Evaluación de la función objetivo---------------------------")
    print("El costo final es:", cost_final)
    return y_solution, A_opti, cost_final