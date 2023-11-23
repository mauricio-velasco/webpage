using JuMP
using GLPK
using LinearAlgebra
#Primero definimos la red capacitada
Vertices = ["o", "a","b","c","d","e","n"] #Primero es la fuente, el ultimo el destino
Edges = [["o","a"], ["o","b"], ["o","c"], ["a","b"], ["a","d"], ["b","e"], ["c","d"], ["c","e"], ["d","n"], ["e","n"]]
Capacidades = [3,1,1,1,1,3,4,4,4,1]
@assert(length(Capacidades) == length(Edges))
Z = [(Edges[j], Capacidades[j]) for j in 1:length(Capacidades)]
#Luego creamos el modelo
numEdges = length(Edges)
numVertices = length(Vertices)
modelo = Model(GLPK.Optimizer)
#Adicionamos las variables
@variable(modelo, f[1:numEdges])
#Ahora hay que crea la matriz de frontera
function boundary_matrix(Vertices, Edges)
    numEdges = length(Edges)
    numVertices = length(Vertices)    
    A=zeros(Float64, numVertices,numEdges)
    for j in 1:numEdges
        edge = Edges[j]
        i_1 = findall(Vertices.==edge[1])[1]
        i_2 = findall(Vertices.==edge[2])[1]
        A[i_2,j] = 1.0
        A[i_1,j] = -1.0
    end
    return A
end

A = boundary_matrix(Vertices,Edges)
B = A*f

#Next we add the conservation of flow constraints
for j in 2:numVertices-1
    @constraint(modelo, B[j]==0)
end
#And the capacity constraints
for j in 1:numEdges
    cvalue = Capacidades[j]
    @constraint(modelo, -cvalue <= f[j]<= cvalue)
end

#and finally the objective function:
@objective(modelo, Max, B[end])
optimize!(modelo)
@show termination_status(modelo)
@show objective_value(modelo)
[@show value(f[j]) for j in 1:numEdges]

