USE SampleTooysGroup;

SELECT * FROM sales;
#verifico che ogni campo ID sia una PK (not null e non duplicati) di ciascuna tabella
SELECT
    COUNT(*) AS TotaleRighe,
    COUNT(CategoryID) AS NotNull,
    COUNT(DISTINCT CategoryID) AS Distinti
FROM Categories;

SELECT
    COUNT(*) AS TotaleRighe,
    COUNT(CountryID) AS NotNull,
    COUNT(DISTINCT CountryID) AS Distinti
FROM Countries;

SELECT
    COUNT(*) AS TotaleRighe,
    COUNT(ProductID) AS NotNull,
    COUNT(DISTINCT ProductID) AS Distinti
FROM Products;

SELECT
    COUNT(*) AS TotaleRighe,
    COUNT(SalesID) AS NotNull,
    COUNT(DISTINCT SalesID) AS Distinti
FROM Sales;

#2)	Esporre l’elenco delle transazioni indicando nel result set
-- il codice documento, la data, il nome del prodotto, la categoria del prodotto, il nome dello stato, il nome della regione di vendita
-- e un campo booleano valorizzato in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno (>180 -> True, <= 180 -> False)
SELECT
	S.SalesID,
    S.Date,
    P.Name,
    C.Name,
    Co.Country,
    R.Name,
    CASE
		WHEN DATEDIFF(curdate(),S.Date) > 180 THEN True ELSE False END '>180gg_flag'
    
FROM Sales S
	LEFT JOIN Products P ON S.ProductID = P.ProductID
    LEFT JOIN Countries Co ON S.CountryID = Co.CountryID
    LEFT JOIN Categories C ON P.CategoryID = C.CategoryID
    LEFT JOIN SalesRegion R ON Co.RegionID = R.RegionID;
    
    
#3)	Esporre l’elenco dei prodotti che hanno venduto, in totale, una quantità maggiore della media delle vendite realizzate nell’ultimo anno censito.
-- (ogni valore della condizione deve risultare da una query e non deve essere inserito a mano).
-- Nel result set devono comparire solo il codice prodotto e il totale venduto.
    
SELECT
    P.Name AS Prodotto,
    SUM(S.Quantity) AS TotaleVenduto
FROM Sales S
join Products P ON S.ProductID = P.ProductID
GROUP BY S.ProductID
HAVING SUM(Quantity) > (
    SELECT
		AVG(Quantity)
		FROM Sales
		WHERE YEAR(Date) = (SELECT MAX(YEAR(Date))
        FROM Sales
    )
);


#4)	Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. 

SELECT
    P.Name AS Prodotto,
    YEAR(S.Date) AS Anno,
    SUM(S.Quantity * P.Price) AS FatturatoTotale
FROM Sales S
JOIN Products P
    ON S.ProductID = P.ProductID
GROUP BY
    P.ProductID,
    P.Name,
    YEAR(S.Date)
ORDER BY
    P.ProductID,
    Anno;
    
#5)	Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.

SELECT
    Co.Country AS Stato,
    YEAR(S.Date) AS Anno,
    SUM(S.Quantity * P.Price) AS FatturatoTotale
FROM Sales S

JOIN Products P ON S.ProductID = P.ProductID
JOIN Countries Co ON S.CountryID = Co.CountryID

GROUP BY
    Co.Country,
    YEAR(S.Date)

ORDER BY
    YEAR(S.Date),
    FatturatoTotale DESC;
    

#6)	Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?

SELECT
    C.Name AS Categoria,
    SUM(S.Quantity) AS QuantitaTotaleVenduta
FROM Sales S

JOIN Products P ON S.ProductID = P.ProductID
JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY
    C.CategoryID,
    C.Name
HAVING SUM(S.Quantity) = (
    SELECT MAX(TotaleVenduto) FROM
    (SELECT
            SUM(S2.Quantity) AS TotaleVenduto
        FROM Sales S2
        JOIN Products P2 ON S2.ProductID = P2.ProductID
        JOIN Categories C2 ON P2.CategoryID = C2.CategoryID
        GROUP BY C2.CategoryID
    ) AS T
);


#7)	Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
-- primo approccio utilizzando IS NULL

SELECT
    P.ProductID,
    P.Name AS Prodotto
FROM Products P
LEFT JOIN Sales S ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL;


-- Un secondo approccio potrebbe essere simile alla verifica delle primary key...utilizzando un count
SELECT
    P.ProductID,
    P.Name AS Prodotto,
    COUNT(S.SalesID) AS NumeroVendite
FROM Products P
LEFT JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY
    P.ProductID,
    P.Name
HAVING COUNT(S.SalesID) = 0;

#8)	Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili
-- (codice prodotto, nome prodotto, nome categoria)

CREATE VIEW VistaDenormalizzata AS
SELECT
    P.ProductID AS CodiceProdotto,
    P.Name AS NomeProdotto,
    C.Name AS NomeCategoria
FROM Products P
LEFT JOIN Categories C ON P.CategoryID = C.CategoryID;
-- verifico
SELECT * FROM VistaDenormalizzata;


#9)	Creare una vista per le informazioni geografiche
    
CREATE VIEW PaesiDenormalizzati AS
SELECT
    Co.Country AS NomeStato,
    R.Name AS NomeRegione
FROM Countries Co
LEFT JOIN SalesRegion R ON Co.RegionID = R.RegionID;
-- verifico
SELECT * FROM PaesiDenormalizzati;
