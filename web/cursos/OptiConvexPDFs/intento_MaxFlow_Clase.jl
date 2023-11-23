using JuMP
using GLPK
using LinearAlgebra

#Primero definimos la red capacitada
Vertices = ["o", "a","b","c","d","e","n"] 
#Primero es la fuente, el ultimo el destino
Edges = [["o","a"], ["o","b"], ["o","c"], ["a","b"], ["a","d"], ["b","e"], ["c","d"], ["c","e"], ["d","n"], ["e","n"]]
Capacidades = [3,1,1,1,1,3,4,4,4,1]
#Creamos la matriz A
function frontera(Vertices, Edges)
    numFilas = length(Vertices)
    numColumnas = length(Edges)
    A = zeros(Float64, numFilas, numColumnas)
    for j in 1:length(Edges)
        current_edge = Edges[j]
        i1 = findall(Vertices.==current_edge[1])[1]
        i2 = findall(Vertices.==current_edge[2])[1]
        A[i1,j] = -1.0
        A[i2,j] = 1.0
    end
    return A
end

modelo = Model(GLPK.Optimizer)
A=frontera(Vertices, Edges)
#Construimos el VECTOR de variables
@variable(modelo, f[1:length(Edges)]) #OJO, nuevo
B=A*f
for j in 2:length(Vertices)-1
    @constraint(modelo, B[j]==0)
end
for j in 1:length(Capacidades)
    cap=Capacidades[j]
    @constraint(modelo, -cap<=f[j]<=cap)
end

@objective(modelo, Max, B[end])
optimize!(modelo)
@show termination_status(modelo)
@show objective_value(modelo)
[@show value(f[j]) for j in 1:length(Edges)]
#Ejercicio: Generalice a algo que construye redes aleatorias, testeee hasta donde puede llegar.
