
USE AdventureWorksLT2019;
GO

--Seleccionar datos básicos:
--Obtén una lista de todos los productos en la tabla "Product".

SELECT*FROM SalesLT.Product;

--Filtrar y ordenar:
--Muestra los nombres de los clientes de la tabla "Customer" en orden alfabético.

SELECT CONCAT(Title,' ',FirstName,' ',MiddleName,' ',LastName) AS 'Customer'
FROM SalesLT.Customer
ORDER BY FirstName,MiddleName,LastName ASC;

--Contar registros:
--¿Cuántos pedidos hay en total en la tabla "SalesOrderHeader"?

SELECT * FROM SalesLT.SalesOrderHeader;
SELECT COUNT(*) AS 'num_pedidos' FROM SalesLT.SalesOrderHeader;

--Uniendo tablas:
--Muestra una lista de nombres de productos junto con sus nombres de categoría de la tabla "Product" y "ProductCategory".

SELECT*FROM SalesLT.Product;
SELECT*FROM SalesLT.ProductCategory;

SELECT p.Name AS 'producto',pc.Name AS 'categoria(subcategoría)', pcp.Name AS 'categoria_padre(categoria)'
FROM SalesLT.Product p 
INNER JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID=pc.ProductCategoryID
INNER JOIN SalesLT.ProductCategory pcp ON pc.ParentProductCategoryID=pcp.ProductCategoryID;

--Agregación:
--Encuentra el total de ventas (columna "TotalDue") para cada año en la tabla "SalesOrderHeader".

SELECT YEAR(DueDate) AS 'año', SUM(TotalDue) AS 'total_ventas' FROM SalesLT.SalesOrderHeader
GROUP BY YEAR(DueDate);

--Filtrar y calcular promedio:
--Calcula el promedio de los montos de descuento en la tabla "SalesOrderHeader", solo para pedidos con un descuento superior al 10%.
SELECT*FROM SalesLT.SalesOrderHeader;
SELECT*FROM SalesLT.SalesOrderDetail;

SELECT  oh.SalesOrderID,
		AVG(od.UnitPrice*od.UnitPriceDiscount) AS 'promedio_montos_descuento',
		CONCAT(AVG(100*od.UnitPriceDiscount),'%') AS '%_promedio_descuento'
FROM SalesLT.SalesOrderHeader oh
INNER JOIN SalesLT.SalesOrderDetail od ON od.SalesOrderID=oh.SalesOrderID
WHERE UnitPriceDiscount>='0.10'
GROUP BY oh.SalesOrderID;

--Subconsultas:
--Encuentra los nombres de los clientes que han realizado al menos un pedido en 2014, utilizando una subconsulta.

SELECT CONCAT(Title,' ',FirstName,' ',MiddleName,' ',LastName) AS 'Customer'
FROM SalesLT.Customer
WHERE CustomerID IN (SELECT CustomerID 
						FROM SalesLT.SalesOrderHeader 
						WHERE YEAR(OrderDate)='2008');




--Uniones múltiples:
--Muestra una lista de nombres de clientes junto con los nombres de sus ciudades y estados correspondientes desde las
--tablas "Customer", "CustomerAddress" y "Address".

SELECT*FROM SalesLT.Customer;
SELECT*FROM SalesLT.CustomerAddress;
SELECT*FROM SalesLT.Address;

SELECT DISTINCT CONCAT(c.Title,' ',c.FirstName,' ',c.MiddleName,' ',c.LastName) AS 'Customer', a.City AS 'ciudad', a.StateProvince AS 'Estado'
FROM SalesLT.Customer c
INNER JOIN SalesLT.CustomerAddress ca ON ca.CustomerID=c.CustomerID
INNER JOIN SalesLT.Address a ON a.AddressID=ca.AddressID


--Ranking y particionamiento:
--Enumera los cinco productos más vendidos en términos de cantidad vendida, junto con la cantidad total vendida de cada uno.

SELECT*FROM SalesLT.Product;
SELECT*FROM SalesLT.SalesOrderDetail;


SELECT TOP 5 p.ProductID,p.Name AS 'Producto', SUM(od.OrderQty) AS 'cantidad_vendida'
FROM SalesLT.Product p
INNER JOIN SalesLT.SalesOrderDetail od ON od.ProductID=p.ProductID
GROUP BY p.ProductID,p.Name
ORDER BY 2 DESC

