kk = QQ
n=5---dimension of P^n
d=3
R = kk[x_0..x_n]

monMap = flatten entries basis(d,R)
DF = transpose(matrix(apply(n+1,j-> apply(monMap, F-> diff(x_j,F)))))---Differential of Veronese map
--Now we compute a collection of random points
k=3
pointsList = apply(k,j->map(kk,R,apply(n+1,j->random(kk))))
TsList = apply(pointsList, m-> m(DF))
Mat = TsList_0
apply(k-1,j-> Mat = Mat| TsList_(j+1))
Mat
----Compare
TerraciniDimSec = rank(Mat)-1
expectedDimSec = min(binomial(n+d,d)-1,k*n+(k-1))

