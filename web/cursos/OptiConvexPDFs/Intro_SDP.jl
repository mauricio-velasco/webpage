using SCS
using JuMP
using LinearAlgebra

#Queremos minimizar x^2-xy+y^2 sobre la esfera.
M  = [
    1 -0.5
    -0.5 1
]
J = 1*Matrix(I,2,2)

#Ejemplo sencillo de como se ponen los constraints definiendo un espectraedro.
modelo = Model(SCS.Optimizer)
@variable(modelo, x)
@SDconstraint(modelo, M-x*J >= 0)
@objective(modelo, Max, x)
optimize!(modelo)
@show termination_status(modelo)
@show objective_value(modelo)

#Veamos la escala, hasta donde se logra esta minimización exacta?
N=20
R=[rand() for i in 1:N, j in 1:N]
M=R+R'
J=1*Matrix(I,N,N)
modelo = Model(SCS.Optimizer)
@variable(modelo, x)
@SDconstraint(modelo, M-x*J >= 0)
@objective(modelo, Max, x)
optimize!(modelo)
@show termination_status(modelo)
@show objective_value(modelo)


