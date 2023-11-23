def profundidad(x,y):
    return 3-3/25*(y*y)

for M in range(40):
    N=M+10
    Sum = 0

    for i in range(N):
        for j in range(N):
            Sum += profundidad(i*(15/N), j*(10/N)-5)*(15/N)*(10/N) 

    print(Sum+" , "+ M)