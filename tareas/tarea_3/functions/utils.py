from itertools import permutations, combinations
import numpy as np

def place_ones(size, count):
    for positions in combinations(range(size), count):
        p = [0] * size

        for i in positions:
            p[i] = 1

        yield p
        
        
def combination_opti(c_ij, f_i, a, y_aux, combi=0):
    cost_optimo = 1e14
    A_opti = np.zeros([len(a),6])
    for i in a:
        for j in a:
            for k in a:
                for l in a:
                    for m in a:
                        for n in a:
                            A = np.array([i,j,k,l,m,n]).T
                            #print(y_aux)
                            #print(A)
                            if len(y_aux)==1:
                                A = A[0]
                                #print(c_ij[y_aux])
                            cost = np.sum(np.multiply(c_ij[y_aux], A))+np.sum(f_i[y_aux])
                                #print("cost:", cost)
                            if cost <=cost_optimo:
                                cost_optimo = cost
                                A_opti = A
    if combi==1:
        return cost_optimo, A_opti
    else:
        return cost_optimo
    
    
    
    
def greedyrandomized(y, c_ij, f_i, p_k, alpha):
    k=0
    y_solution = []
    while len(y_solution)<p_k:
        var_libres = 12-len(y_solution)
        costos = []
        a = list(place_ones(len(y_solution)+1, 1))
        # print("a:", a)
        for inst in y:
            y_aux = y_solution.copy()
            y_aux.append(inst)
            cost_optimo = combination_opti(c_ij, f_i, a, y_aux)
            costos.append(cost_optimo)
         
        print("costos:", costos)
        c_max = np.max(costos)
        c_min = np.min(costos)
        #print("c_max", c_max)
        #print("c_min", c_min)
        lim_sup = c_min+alpha*(c_max-c_min)
        #print("lim:", alpha)
        RL = np.concatenate(np.argwhere(costos <= lim_sup))
        print(RL)
        rand = np.random.choice(RL, 1)
        #print(rand)
        y_solution.append(y[rand[0]])
        print("Instacias seleccionadas", np.array(y_solution)+1)
        #print(len(y_solution))
        print("Costo optimo de las instacias selecionadas.", costos[rand[0]])
        y.remove(y[rand[0]])
    return y_solution


def grasp(y, c_ij, f_i, p_k, alpha):
    y_opt = greedyrandomized(y, c_ij, f_i, p_k, alpha)
        
    a = list(place_ones(len(y_opt), 1))
    A_opti = np.zeros([4,6])
    cost_final, A_opti = combination_opti(c_ij, f_i, a, y_opt, 1)
    print("---------------------------------------------------------")
    print("---------------------------------------------------------")
    print("---------------------------------------------------------")

    print("Las instalaciones que se tiene que abrir son", np.array(y_opt)+1)
    print("Las asignaciones de las instalaciones clientes son:")
    print(np.array(A_opti))
    print("El costo final es:", cost_final)
    return 0