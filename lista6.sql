-----------------------------------------PARTE 1-------------------------------------------------------------------------
--A
DELETE FROM CUSTOMER 
WHERE CDCUSTOMER NOT IN (SELECT DISTINCT CDCUSTOMER FROM REQUEST)


DELETE FROM CUSTOMER 
FROM REQUEST R 
INNER JOIN CUSTOMER C ON R.CDCUSTOMER = C.CDCUSTOMER
INNER JOIN PRODUCTREQUEST PR ON R.CDREQUEST = PR.CDREQUEST
WHERE PR.CDPRODUCT IS NULL


--B
DELETE FROM SUPPLIER
WHERE CDSUPPLIER NOT IN (SELECT DISTINCT CDSUPPLIER FROM PRODUCT)


DELETE FROM SUPPLIER
FROM PRODUCT P
INNER JOIN SUPPLIER S ON P.CDSUPPLIER=S.CDSUPPLIER
WHERE P.CDSUPPLIER IS NULL

--C
UPDATE PRODUCTREQUEST
SET PRODUCTREQUEST.VLUNITARY=PRODUCT.VLPRICE
FROM PRODUCTREQUEST
INNER JOIN PRODUCT ON PRODUCTREQUEST.CDPRODUCT=PRODUCT.CDPRODUCT

UPDATE REQUEST	
SET VLTOTAL = PRODUCTREQUEST.VLUNITARY
FROM PRODUCTREQUEST

--D 
ALTER TABLE dbo.SUPPLIER
ADD DSSTATUS VARCHAR(10);

--E
UPDATE SUPPLIER 

SET DSSTATUS = 'INATIVO'

FROM SUPPLIER S
WHERE CDSUPPLIER NOT IN(SELECT DISTINCT CDSUPPLIER FROM PRODUCT);

--F
UPDATE CUSTOMER

SET NMADRESS = 'DESCONHECIDO'

FROM  CUSTOMER S
WHERE NMADRESS IS NULL

--G
INSERT INTO PRODUCTREQUEST (NMPRODUCT, QTSTOCK)
SELECT NMPRODUCT, 10 AS QTSTOCK
FROM PRODUCT

 INSERT INTO PRODUCTREQUEST (CDREQUEST, CDPRODUCT, QTAMOUNT, VLUNITARY)

 SELECT R.CDREQUEST, P.CDPRODUCT, 10, P.VLPRICE

 FROM PRODUCTREQUEST PR

 INNER JOIN PRODUCT P ON PR.CDPRODUCT = P.CDPRODUCT
 INNER JOIN REQUEST R ON PR.CDREQUEST = R.CDREQUEST


-----------------------------------------------PARTE2----------------------------------------------------------------
--A 
SELECT P.NMPRODUCT,C.NMCUSTOMER,
COUNT(PR.QTAMOUNT) AS VZTOTALCOMPRADO,
SUM (PR.QTAMOUNT) AS VLGASTO,
SUM((PR.QTAMOUNT)* (PR.VLUNITARY)) AS TOTALGASTO

FROM REQUEST R
INNER JOIN CUSTOMER C ON R.CDCUSTOMER=C.CDCUSTOMER
INNER JOIN PRODUCTREQUEST PR ON R.CDREQUEST=PR.CDREQUEST
INNER JOIN PRODUCT P ON PR.CDPRODUCT=P.CDPRODUCT

GROUP BY P.NMPRODUCT, C.NMCUSTOMER

--B
SELECT NMCUSTOMER,
COUNT(CDREQUEST) AS NUMPEDIDOS,
SUM(VLTOTAL) AS TOTALCOMPRADO

FROM CUSTOMER
INNER JOIN REQUEST ON CUSTOMER.CDCUSTOMER=REQUEST.CDCUSTOMER

WHERE DTREQUEST BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY NMCUSTOMER

--C
SELECT S.NMSUPPLIER, S.IDFONE, P.NMPRODUCT, P.VLPRICE, P.QTSTOCK
FROM SUPPLIER S 
INNER JOIN PRODUCT P ON S.CDSUPPLIER=P.CDSUPPLIER
INNER JOIN PRODUCTREQUEST PR ON P.CDSUPPLIER=S.CDSUPPLIER

--D
SELECT C.NMCUSTOMER , R.DTREQUEST, R.VLTOTAL
FROM REQUEST R
INNER JOIN CUSTOMER C  ON R.CDCUSTOMER=C.CDCUSTOMER

