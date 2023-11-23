using JuMP
using COSMO #ECOS tambien funciona, es necesario haberlos cargado antes
# import Pkg y luego Pkg.add("COSMO")
#We minimize a linear function over the unit disc.
modelo = Model(COSMO.Optimizer)
@variable(modelo, x[i=1:3])
@constraint(modelo, res , [1.0, x[1],x[2],x[3]] in SecondOrderCone()); # ||M'x|| <= γ
@objective(modelo, Max, x[1]+x[2]+x[3])
optimize!(modelo)
@show termination_status(modelo)
@show objective_value(modelo)


