using DynamicPolynomials
using JuMP
using SCS
using Plots
#Queremos minimizar polinomios univariados en TODA la recta real.
@polyvar x
p = x^6-7*x^4+8*x^2+0.1*x^3+1
plot(s->p(x=>s),-2.5,2.5)

#Empecemos con x^4-3x^2+1
half_deg = 3
Mons = [x^j for j in 0:half_deg]
l = length(Mons)
modelo = Model(SCS.Optimizer)
@variable(modelo, X[1:l,1:l], PSD)
@variable(modelo,z)
expr = p-z-Mons'*X*Mons #Queremos que esto sea cero, asi que nos determina los constraints
coefficient_constraints = expr.a
for res in coefficient_constraints
    @constraint(modelo, res==0)
end
@objective(modelo, Max, z)
optimize!(modelo)
@show termination_status(modelo)
res = @show objective_value(modelo)
hline!([res], color=:red, label="2")
print("Listo!")
