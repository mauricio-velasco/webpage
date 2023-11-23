from sympy import * 

#Problema 1: de la autopista
t=symbols("t")
a=symbols("a")
integrand_1 = (1+t*(a-1))**2+(2-t)**2
r1 = integrate(integrand_1,(t,0,1))
#Temas A,B y C
a1 = r1.subs(a,2)
a2 = r1.subs(a,3)
a3 = r1.subs(a,4)
print(a1,a2,a3)

#Problema 2: hoof of archimedes:
r,t,z,a=symbols("r,t,z,a")
integrand = r
I1 = integrate(integrand, (z,0,a*r*sin(t)))
I2 =  integrate(I1, (r,0,1))
I3 = integrate(I2,(t,0,pi))
print(I3)
a1 = I3.subs(a,3)
a2 = I3.subs(a,6)
a3 = I3.subs(a,9)
print(a1,a2,a3)

#Problema 3: momento de inercia de un cono:
r,t,z,c=symbols("r,t,z,c")
integrand = 2*r**3
I1 = integrate(integrand, (z,r/c,15))
I2 =  integrate(I1, (r,0,15*c))
I3 = integrate(I2,(t,0,2*pi))
r=I3
a1 = r.subs(c,Rational(1,15))
a2 = r.subs(c,Rational(2,15))
a3 = r.subs(c,Rational(3,15))
print(a1,a2,a3)

#Problema 4: Volumen en esfericas
rho,t,phi,b=symbols("rho,t,phi,b")
integrand = rho**2*sin(phi)
I1 = integrate(integrand, (rho, 0, b*sin(phi)**Rational(1,3)))
I2 = integrate(I1,(phi,0,pi))
I3 = integrate(I2,(t,0,2*pi))
print(I3)
r=I3
a1 = r.subs(b,1)
a2 = r.subs(b,3)
a3 = r.subs(b,6)
print(a1,a2,a3)

#Problema 5: Cambio orden integracion
x,y,b = symbols("x,y,b")
integrand = exp(y**3)
I1 = integrate(integrand, (x,0,b*y**2))
I2 = integrate(I1, (y,0,1))
print(I2)
