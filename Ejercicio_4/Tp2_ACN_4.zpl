
# Conjuntos
set P := { "Producto A", "Producto B", "Producto C", "Producto D", "Producto E"}; # Productos
set M := { 1 .. 24 }; # Meses de producción
set M_s := { 0 .. 24 }; # Meses de almacenamiento


# Parámetros
param d[M*P] := read "../Datos_final.txt" as "n+";      # demanda
param costo := 370;                                  # costo por unidad 
param capProd := 120;                                # capacidad maxima de prod. por mes
param capDep := 900;                                 # capacidad maxima del deposito 
param maxProd := 300;				                 # limite maximo de produccion en los meses
param costoTerciarizar := 540;			             # costo de cada unidad terciarizada
param maxTerciarizar := 200;			             # fabricacion maxima a terciarizar
param minProdTerc := 20;			                 # fabricacion minima de cada producto terciarizado

# Variables
var x[M*P] >= 0; # Unidades a fabricar de producto p en el mes m
var s[M_s*P] >= 0; # Stock del producto p al final del mes m
var w[M*P] integer;
var z[M*P] integer >= 0; # Unidades terciarizadas del producto p en el mes m
var v[M*P] binary;

# Función objetivo: minimizar costo de fabricación
minimize fobj: sum <m,p> in M*P: (costo * x[m,p] + costoTerciarizar * z[m,p]);

# Restricciones 

# Definición de Stock
subto defstock: forall <m,p> in M*P: 
    s[m, p] == s[m-1, p] + x[m, p] + z[m,p] - d[m,p];

# Capacidad de producción maxima de cada producto por mes
subto maxprod: forall <m,p> in M*P:
    x[m,p] <= capProd;

# Limite de produccion maxima mensual
subto limmax: forall <m> in M:
    sum <p> in P: x[m,p] <= maxProd;

# Lotes de 10 unidades
subto lotes: forall <m,p> in M*P:
    x[m,p] == 10 * w[m,p];

# Capacidad Maxima del deposito
subto maxstock: forall <m> in M: 
    sum <p> in P: s[m,p] <= capDep; 

# Stock inicial en cero 
subto stockinicial: forall <p> in P:
    s[0, p] == 0;

# Maxima fabricacion de unidades terciarizadas
subto limterc: forall <m> in M:
    sum <p> in P: z[m,p] <= maxTerciarizar;

############################################################

# Escribimos restriccion para que la v[m,p] no sea 0 siempre.
subto resbinaria: forall <m,p> in M*P:
    z[m,p] <= maxTerciarizar * v[m,p];

# Minima fabricacion de productos terciarizados
subto minterc: forall <m,p> in M*P:
    z[m,p] >= minProdTerc * v[m,p];





