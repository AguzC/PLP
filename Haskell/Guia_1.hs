--3.
--I. Redefinir usando foldr las funciones sum, elem, (++), filter y map.

{-
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr z [] = z
foldr f z (x:xs) = f x (foldr f z xs)

Si xs = [x1, x2, x3] entonces:
foldr f z xs = f x1 (f x2 (f x3 z))

Equivalentemente con notaci´on infija:
foldr ⋆ z xs = x1 ⋆ (x2 ⋆ (x3 ⋆ z))
-}

sumFoldr :: (Num a) => [a] -> a
sumFoldr = foldr (+) 0
--sumFoldr = foldr (\x rec -> x + rec) 0, son lo mismo

elemFoldr :: (Eq a) => a -> [a] -> Bool
--elemFoldr y = foldr (\x rec -> x == y || rec) False
elemFoldr y = foldr ((||) . (==y)) False --Cualquiera de las 2 funca,(||) . (==y) es = a 
-- hacer || (x==y) kinda.

filterFoldr :: (a -> Bool) -> [a] -> [a]
filterFoldr p = foldr (\x rec -> if p x then x : rec else rec) []

mapFoldr :: (a -> b) -> [a] -> [b]
--mapFoldr f = foldr (\x rec -> f x : rec) []
mapFoldr f = foldr ((:).f) []

--II.
--Definir la función mejorSegún :: (a -> a -> Bool) -> [a] -> a, que devuelve el máximo elemento
--de la lista según una función de comparación, utilizando foldr1. Por ejemplo, maximum = mejorSegún (>).

mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun f = foldr1 (\x rec -> if f x rec then x else rec) 

--foldr1, variante de foldr que no tiene caso base, entonces solo se puede aplicar a estructuras 
--no vacias, es una funcion parcial debido a eso.

--III. Definir la función sumasParciales :: Num a => [a] -> [a], que dada una lista de números devuelve
--otra de la misma longitud, que tiene en cada posición la suma parcial de los elementos de la lista original
--desde la cabeza hasta la posición actual. Por ejemplo, sumasParciales [1,4,-1,0,5] -> [1,5,4,4,9].

-- 1 = 1, 1 + 4 = 5, 1 + 4 + (-1) = 4, 1 + 4 + (-1) + 0 = 4, 1...+ 5 = 9
--En cada caso tengo que devolver la suma de los lugares anteriores.
--El primer lugar tiene la suma de los elementos de [0] a [0],
-- Digo a = [1,4,-1,0,5]
-- sumasParciales a = [sum (take 1 a) , sum (take 2 a) , sum (take 3 a) , sum (take 4 a) , sum (take 5 a)]

sumasParciales :: Num a => [a] -> [a]
sumasParciales xs = reverse (foldr (\x rec -> sum (take (length rec + 1) xs)  :rec ) [] xs)

--Problema: Necesito que el primer argumento del take vaya aumentando, puedo usar la longitud de xs que 
-- va variando(?,0..............

sumasParciales1 :: (Num a) => [a] -> [a]
sumasParciales1 = foldr (\x rec -> x : sumarX x rec) []

sumarX :: (Num a) => a -> [a] -> [a]
sumarX x = map (+ x)


--IV. Definir la función sumaAlt, que realiza la suma alternada de los elementos de una lista. Es decir, da como
--resultado: el primer elemento, menos el segundo, más el tercero, menos el cuarto, etc. Usar foldr.
--Poco vale este porq me lo spoilee

sumaAlt:: (Num a) => [a] -> a
sumaAlt = foldr (-) 0

--V.Hacer lo mismo que en el punto anterior, pero en sentido inverso (el último elemento menos el anteúltimo,
--  etc.). Pensar qué esquema de recursión conviene usar en este caso.

sumaAlt2:: (Num a) => [a] -> a
sumaAlt2 xs = foldr (-) 0 (reverse xs)
--Quizas el reverse aca es trampa, god knows.


--4.
--I. Definir la función permutaciones :: [a] -> [[a]], que dada una lista devuelve todas sus permutaciones. 
--Se recomienda utilizar concatMap :: (a -> [b]) -> [a] -> [b], y también take y drop.
-- ej: [1,2,3] , f [1,2,3] = [[1,2,3][1,3,2][2,1,3][2,3,1][3,1,2][3,2,1]]

--permutaciones:: (Eq a) => [a] -> [[a]]
--permutaciones xs = foldr (\x rec -> combiUnicoElem x (length xs) (filter (/=x) xs) ++ rec) [] xs
--permutaciones xs = foldr (\x -> concatMap id (combiUnicoElem x (length xs) (filter (/=x) xs))) [] xs
--permutaciones xs = foldr (concatMap . combiUnicoElem length xs) [] 
--permutaciones xs = concatMap (foldr (\x rec -> combiUnicoElem x (length xs) (filter (/=x) xs)) ++ rec) [] xs)
--permutaciones xs = concatMap (foldr foo [] xs)
--foo = (\x rec -> combiUnicoElem x (length xs) (filter (/=x) xs)) ++ rec)

--concatMap :: Foldable t => (a -> [b]) -> t a -> [b]
--combiUnicoElem :: a -> [a] -> [[a]]

{- permutaciones:: (Eq a) => [a] -> [[a]]

permutaciones xs = foldr (\x -> concatMap (combiUnicoElem (length xs)) xs) [[]] xs



combiUnicoElem:: Int -> a -> [a] -> [[a]] --Pre: a no pertenece a la lista
combiUnicoElem 0 x xs = [x : xs]
combiUnicoElem long x xs = (take long xs ++ [x] ++ drop long xs) : combiUnicoElem (long - 1) x xs  

combiUnicoElem':: a -> [a] -> [[a]]
combiUnicoElem' x xs = foldr (\x xs -> take (length xs) xs ++ [x] ++ drop (length xs) xs) [] xs
 -}
permutaciones2:: [a] -> [[a]]
permutaciones2 = foldr (\x -> concatMap (intercalarElem x)) [[]]

intercalarElem :: a -> [a] -> [[a]]
intercalarElem e xs = [take i xs ++ [e] ++ drop i xs | i <- [0 .. length xs]]



--5. 


--Considerar las siguientes funciones y indicar si la recursión utilizada en cada una de ellas es o no estructural. 
--Si lo es, reescribirla utilizando foldr, En caso contrario, explicar el motivo.

--a
{- elementosEnPosicionesPares :: [a] -> [a]
elementosEnPosicionesPares [] = []
elementosEnPosicionesPares (x:xs) = if null xs
                                       then [x]
                                       else x : elementosEnPosicionesPares (tail xs) -}

--b
{- entrelazar :: [a] -> [a] -> [a]
entrelazar [] = id
entrelazar (x:xs) = \ys -> if null ys
                           then x : entrelazar xs []
                           else x : head ys : entrelazar xs (tail ys)
 -}

--a.
-- No es estructural, en el llamado recursivo usa el valor de xs.
--b.
-- Esta es legal:

--entrelazar' :: [a] -> [a] -> [a]

{- entrelazar' xs ys = foldr (\x rec ys -> if null ys
                              then x : rec 
                              else x : head ys : rec  (tail ys)) id xs -}



entrelazar1 :: [a] -> ([a] -> [a])
entrelazar1 = foldr (\x rec ys -> 
                    if null ys
                    then x : rec [] 
                    else x : head ys : rec (tail ys)
                    ) (const []) 


--6

sacarUna :: Eq a => a -> [a] -> [a]
sacarUna e = recr (\x xs rec ->
                       if x == e 
                       then xs
                       else x : rec ) [] 



--6 c

insertarOrdenado :: Ord a => a -> [a] -> [a]
insertarOrdenado e = recr (\x xs rec -> 
                           if  e > x 
                           then x : rec 
                           else e : x : xs) [e]


--7a


mapPares :: (a -> c -> b) -> [(a,c)] -> [b]
mapPares f xs = foldr (\x rec -> uncurry f x : rec) [] xs
-- o tambien map (\ x -> uncurry f x)
-- o mejor aun map (uncurry f)


--7b

armarPares:: [a] -> ([b] -> [(a,b)])
armarPares = foldr (\x rec ys ->
                          if null ys
                          then []
                          else (x,head ys) : rec (tail ys)) (const []) 

--Insight: Si haces un foldr de algo que toma 2 parametros para resolver, entonces 
--existe una funcion parcialmente aplicada, asiq el caso base no puede ser solo el 
--operador de la lista vacia, sino uno que tome el argumento que le metan y ahi 
--devuelva la lista vacia.
--Y el orden de los parametros es siempre x (cabeza) , rec (paso recursivo), ys (lo
--que quieras)

--7c 

mapDoble:: (a -> b -> c) -> [a] -> [b] -> [c]
mapDoble f xs ys = mapPares f (armarPares xs ys)


{-
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr z [] = z
foldr f z (x:xs) = f x (foldr f z xs)

Si xs = [x1, x2, x3] entonces:
foldr f z xs = f x1 (f x2 (f x3 z))

Equivalentemente con notaci´on infija:
foldr ⋆ z xs = x1 ⋆ (x2 ⋆ (x3 ⋆ z))
-}

armarPares':: [a] -> [b] -> [(a,b)]
armarPares' [] _ = []
armarPares' _ [] = []
armarPares' (x:xs) (y:ys) = (x,y) : armarPares' xs ys 


--8a
{- Escribir la función sumaMat, que representa la suma de matrices, usando zipWith. Representaremos una
matriz como la lista de sus filas. Esto quiere decir que cada matriz será una lista finita de listas finitas,
todas de la misma longitud, con elementos enteros. Recordamos que la suma de matrices se define como
la suma celda a celda. Asumir que las dos matrices a sumar están bien formadas y tienen las mismas
dimensiones -}

sumaMat:: [[Int]] -> [[Int]] -> [[Int]]
sumaMat = foldr (\x rec ys -> zipWith (+) x (head ys) : rec (tail ys)) (const [])

--8b 
{- Escribir la función trasponer, que, dada una matriz como las del ítem i, devuelva su traspuesta. Es decir,
en la posición i, j del resultado está el contenido de la posición j, i de la matriz original. Notar que si la
entrada es una lista de N listas, todas de longitud M, la salida debe tener M listas, todas de longitud N. -}

{- trasponer:: [[Int]] -> [[Int]]
trasponer -} 


trasponer :: [[Int]] -> [[Int]]
trasponer m = foldr (\xs rec -> zipWith (:) xs rec) (replicate (length (head m)) []) m
--Esto esta copiado de honi, es increible la verdad.

recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr _ z [] = z
recr f z (x : xs) = f x xs (recr f z xs)


--9a
--data Nat = Cero | Succ Nat


foldNat :: (Integer -> b -> b) -> b -> Integer -> b
foldNat f z 0 = z --WHY?????
foldNat f z n = f n (foldNat f z (n-1))


potencia :: Integer -> Integer -> Integer
potencia x n = foldNat (\n rec -> x * rec) 1 n

--10a.

{- Definir la función genLista :: a -> (a -> a) -> Integer -> [a], que genera una lista de
una cantidad dada de elementos, a partir de un elemento inicial y de una función de incremento 
entre los elementosde la lista. Dicha función de incremento, dado un elemento de la lista, devuelve 
el elemento siguiente. -}


genLista :: a -> (a -> a) -> Integer -> [a]
genLista inicial incremento cant = foldNat (\x rec -> inicial : map incremento rec) [] (cant +1)

{- genListaRec:: a -> ((a -> a) -> (Integer -> [a]))
genListaRec ini f 0 = []
genListaRec ini f n = f ini : genListaRec (f ini) f (n-1)     -}


--10.b
{- Usando genLista, definir la función desdeHasta, que dado un par de números (el primero menor que el
segundo), devuelve una lista de números consecutivos desde el primero hasta el segundo. -}


desdeHasta :: Integer -> Integer -> [Integer]
desdeHasta a b = genLista a (+1) (b-a)


--11.

data Polinomio a = X 
    | Cte a 
    | Suma (Polinomio a) (Polinomio a) 
    | Prod (Polinomio a) (Polinomio a)


foldPoli:: b -> (a -> b) -> (b -> b -> b) -> (b -> b -> b) -> Polinomio a -> b
foldPoli fx fcte fsuma fprod poli =
    case poli of
        X           -> fx
        Cte a       -> fcte a
        Suma a b    -> fsuma (rec a) (rec b)
        Prod a b    -> fprod (rec a) (rec b)
    where rec = foldPoli fx fcte fsuma fprod

evaluar:: Num a => a -> Polinomio a -> a
evaluar a = foldPoli a id (+) (*)

--12a.

data AB a = Nil | Bin (AB a) a (AB a)

foldAB :: b -> (b -> a -> b -> b) -> AB a -> b
foldAB fNil fBin ab =
    case ab of 
        Nil         -> fNil
        Bin i r d   -> fBin (rec i) r (rec d)
    where rec = foldAB fNil fBin

recAB :: b -> (AB a -> a -> AB a -> b -> b -> b) -> AB a -> b
recAB fNil fBin ab = 
    case ab of 
        Nil         -> fNil
        Bin i r d   -> fBin i r d (rec i) (rec d) 
    where rec = recAB fNil fBin


--12b.

esNil :: AB a -> Bool
esNil x = 
    case x of 
        Nil -> True
        _   -> False 

altura :: AB a -> Int
altura = foldAB 0 (\d r i -> 1 + max d i)

cantNodos :: AB a -> Int 
cantNodos = foldAB 0 (\d r i -> 1 + d + i)

--12c.

mejorSegun :: (a -> a -> Bool) -> AB a -> a
mejorSegun f = foldAB () (\d r i -> f r ) 


ignorarNil :: AB a -> 


{-
Hay que comparar los elementos y quedarse con el 
mejor segun f, tendiendo r , i y d

-}
