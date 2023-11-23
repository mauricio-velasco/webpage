using Plots

p=11
N=90
x=1:N
y1 = [(1/p)*sum([cos((2*pi/p)*j)^n for j in 0:p-1]) for n in 1:N]
y2= (1/p) * ones(N,1)
y = [y1,y2]
plot(x,y)
