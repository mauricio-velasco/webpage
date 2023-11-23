using JuMP
using GLPK
modelo = Model(GLPK.Optimizer)
print(modelo)
#Adicionar variables
@variable(modelo, x1>=0)
@variable(modelo, x2>=0)
@variable(modelo, x3>=0)
#Adicionar restricciones
@constraint(modelo, vitaA, 35x1+0.5x2+0.5x3>=0.5)
@constraint(modelo, vitaB, 60x1+300x2+10x3>=15)
@constraint(modelo, Fibra, 30x1+20x2+10x3>=4.0)
@constraint(modelo, Compacto, x1+x2+x3<=20.0)

#Adicionamos la funcion objetivo
@objective(modelo, Min, 0.75x1+0.5x2+0.15x3)
optimize!(modelo)
@show objective_value(modelo)
[@show value(x) for x in [x1,x2,x3]]
@show termination_status(modelo)
