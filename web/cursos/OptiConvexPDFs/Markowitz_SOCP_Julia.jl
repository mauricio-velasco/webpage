using LinearAlgebra
using Statistics
using Plots
#Datos de precios de tres acciones en periodos consecutivo
# Monthly prices 2000,2001 de IBM WMT y SEHI
stock_data = [
    93.043 51.826 1.063;
    84.585 52.823 0.938;
    111.453 56.477 1.000;
    99.525 49.805 0.938;
    95.819 50.287 1.438;
    114.708 51.521 1.700;
    111.515 51.531 2.540;
    113.211 48.664 2.390;
    104.942 55.744 3.120;
    99.827 47.916 2.980;
    91.607 49.438 1.900;
    107.937 51.336 1.750;
    115.590 55.081 1.800;]  #13x3 SparseArrays

plot(stock_data)    
#Calculo del vector de retornos
stock_returns = Array{Float64}(undef, 12, 3) 
for i in 1:12 
    stock_returns[i, :] = (stock_data[i + 1, :] .- stock_data[i, :]) ./ stock_data[i, :] 
end 
#Calculo de la media y matriz de varianzas covarianzas
r = Statistics.mean(stock_returns, dims = 1)
Q = Statistics.cov(stock_returns)
#Verificaciones de PSD
Q == transpose(Q)
[eigvals(Q)[j] > 0.0 for j in 1:3]
B = factorize(Q).L
B' == factorize(Q).U
Q-B*B'#Factorización de Choleski.
Q
#Modelo de optim*izacion:
using JuMP
using COSMO
portafolio = Model(COSMO.Optimizer)
@variable(portafolio, x[1:3] >=0) #Variables son un VECTOR con entradas positivas
@objective(portafolio, Min, x'*Q*x) # Queremos minimizar riesgo
@constraint(portafolio, sum(x)<=1000) #Acotando la suma del capital total
@constraint(portafolio, sum(r[i]*x[i] for i in 1:3) >= 1000.0 ) #Y el retorno mensual minimo.
optimize!(portafolio)
@show termination_status(portafolio)
@show objective_value(portafolio)
sqrt(223)
[@show value(x[j]) for j in 1:3]
r*value.(x)


