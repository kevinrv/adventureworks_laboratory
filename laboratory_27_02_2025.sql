/*
Obtener una tabla completa con información relevante sobre los productos, incluyendo:

ID del producto
Nombre del producto
Precio de venta (ListPrice)
Costo de producción (StandardCost)
Margen de ganancia (ListPrice - StandardCost)
Total de unidades vendidas
Monto total vendido
Cantidad de veces que fue ordenado (cantidad de órdenes donde aparece el producto)

*/

USE AdventureWorks2019;
GO

SELECT
	pc.Name AS 'categoria',
	ISNULL(sc.Name,'No registra') AS 'sub_categoria',
	pr.ProductID AS 'Producto_ID',
	pr.Name AS 'Nombre_producto',
	pr.ListPrice AS 'Precio_lista',
	pr.StandardCost AS 'Costo_producción',
	pr.ListPrice-pr.StandardCost AS 'Margen_ganacia',
	((pr.ListPrice-pr.StandardCost)/pr.ListPrice)*100 AS '% ganancia',
	ISNULL(SUM(od.OrderQty),0) AS 'total_unidades_vendidas',
	CAST(ROUND(ISNULL(SUM(od.LineTotal),0),2) AS DECIMAL(9,2)) AS 'monto_total_vendido',
	COUNT(DISTINCT od.SalesOrderID) AS 'cantidad_veces_ordenado'
FROM Production.Product pr
	LEFT JOIN Sales.SalesOrderDetail od ON od.ProductID=pr.ProductID
	LEFT JOIN Production.ProductSubcategory sc ON sc.ProductSubcategoryID=pr.ProductSubcategoryID
	INNER JOIN Production.ProductCategory pc ON pc.ProductCategoryID=sc.ProductCategoryID
GROUP BY 
	pc.Name,
	sc.Name,
	pr.ProductID,
	pr.Name,
	pr.ListPrice,
	pr.StandardCost
ORDER BY 9 DESC;

SELECT*FROM Production.Product;
SELECT*FROM Sales.SalesOrderDetail;
SELECT*FROM Production.ProductCategory;
SELECT*FROM Production.ProductSubcategory;

