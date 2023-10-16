
# Conjuntos
set P := { "Producto A", "Producto B", "Producto C", "Producto D", "Producto E"}; # Productos
set M := { 1 .. 24 }; # Meses de producción
set M_s := { 0 .. 24 }; # Meses de almacenamiento


# Parámetros
param d[M,P] := table [read "datos.csv" as "<1s>,5*<n>"] <rowName, colName, value>;     # demanda
param costo := 370;                                                                     # costo por unidad 
param capProd := 120;                                                                   # capacidad maxima de prod. por mes
param capDep := 900;                                                                    # capacidad maxima del deposito 

# Variables
var x[M,P] >= 0; # Unidades a fabricar de producto p en el mes m
var s[M_s,P] >= 0; # Stock del producto p al final del mes m

# Función objetivo: minimizar costo de fabricación
minimize fobj: sum <m in M, p in P> costo * x[m,p];

# Restricciones 

# Definición de Stock
subto defstock: forall <m in M, p in P> do 
    s[m, p] = s[m-1, p] + x[m, p] - d[m,p];

# Capacidad de producción maxima de cada producto por mes
subto maxprod: forall <m in M, p in P> do
    x[m,p] <= capProd;

# Lotes de 10 unidades
subto lotes: forall <m in M, p in P> do
    x[m,p] mod 10 = 0;

# Capacidad Maxima del deposito
subto maxstock: forall <m in M> do 
    sum <p in P> s[m,p] <= capDep; 

# Stock inicial en cero 
subto stockinicial: forall <p in P> do
    s[0, p] = 0;



