using JuMP
using DynamicPolynomials
using Plots

@polyvar x
p=x^4-x^2+0.5*x^3+x-1
plot(s->p(x=>s),-1.25,0.9)
mons = [x^j for j in 0:2]
l=length(mons)
modelo = Model(SCS.Optimizer)
@variable(modelo, z)
@variable(modelo, A[1:l,1:l], PSD)
res = p-z-mons'*A*mons
restr = res.a
for res in restr
    @constraint(modelo,res==0)
end
@objective(modelo,Max,z)
optimize!(modelo)
@show termination_status(modelo)
opt = @show objective_value(modelo)
hline!([opt],color="red")
X = JuMP.value.(A)

#Nuestro resultado numérico tiene un valor propio negativo!!
X = X+0.00001*I
C=factorize(X).U
w = C*mons
w[1]^2+w[2]^2+w[3]^2-p

