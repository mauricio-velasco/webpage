using JuMP
using ECOS


items  = [:Gold, :Silver, :Bronze]
values = Dict(:Gold => 5.0,  :Silver => 3.0,  :Bronze => 1.0)
weight = Dict(:Gold => 2.0,  :Silver => 1.5,  :Bronze => 0.3)

model = Model(ECOS.Optimizer)
@variable(model, 0 <= take[items] <= 1)  # Define a variable for each item
@objective(model, Max, sum(values[item] * take[item] for item in items))
@constraint(model, sum(weight[item] * take[item] for item in items) <= 3)
optimize!(model)

println(value.(take))
# take
# [  Gold] = 0.9999999680446406
# [Silver] = 0.46666670881026834
# [Bronze] = 0.9999999633898735

using LinearAlgebra, SparseArrays, Random, JuMP, Test

## generate the data
rng = Random.MersenneTwister(1)
k = 5; # number of factors
n = k * 10; # number of assets
D = spdiagm(0 => rand(rng, n) .* sqrt(k))
F = sprandn(rng, n, k, 0.5); # factor loading matrix
μ = (3 .+ 9. * rand(rng, n)) / 100. # expected returns between 3% - 12%
γ = 1.0; # risk aversion parameter
d = 1 # we are starting from all cash
x0 = zeros(n);
model = JuMP.Model(ECOS.Optimizer);
@variable(model, x[1:n]);
@variable(model, y[1:k]);
@objective(model, Min,  x' * D * x + y' * y - 1/γ * μ' * x);
@constraint(model, y .== F' * x);
@constraint(model, sum(x) == d + sum(x0));
@constraint(model, x .>= 0);
JuMP.optimize!(model)
Mt = [D.^0.5; F']
model = JuMP.Model(ECOS.Optimizer);
@variable(model, x[1:n]);
@objective(model, Min, - μ' * x);
@constraint(model,  [γ; Mt * x] in SecondOrderCone()); # ||M'x|| <= γ
@constraint(model, sum(x) == d + sum(x0));
@constraint(model, x .>= 0);
JuMP.optimize!(model)
@show objective_value(model)
