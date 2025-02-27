Use AdventureWorks2019;
GO

DECLARE vend_cursor CURSOR  
    FOR SELECT * FROM Purchasing.Vendor  
OPEN vend_cursor  
FETCH NEXT FROM vend_cursor; 
CLOSE vend_cursor;
DEALLOCATE vend_cursor;

SELECT*FROM Purchasing.Vendor  

SET NOCOUNT ON;  
  
DECLARE @vendor_id INT, @vendor_name NVARCHAR(50),  
    @message VARCHAR(80), @product NVARCHAR(50);  
  
PRINT '-------- Vendor Products Report --------';  
  
DECLARE vendor_cursor CURSOR FOR   
SELECT BusinessEntityID, Name  
FROM Purchasing.Vendor  
WHERE PreferredVendorStatus = 1  
ORDER BY BusinessEntityID;  
  
OPEN vendor_cursor  
  
FETCH NEXT FROM vendor_cursor   
INTO @vendor_id, @vendor_name  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT @message = '----- Products From Vendor: ' +   
        @vendor_name  
  
    PRINT @message  
  
    -- Declare an inner cursor based     
    -- on vendor_id from the outer cursor.  
  
    DECLARE product_cursor CURSOR FOR   
    SELECT v.Name  
    FROM Purchasing.ProductVendor pv, Production.Product v  
    WHERE pv.ProductID = v.ProductID AND  
    pv.BusinessEntityID = @vendor_id  -- Variable value from the outer cursor  
  
    OPEN product_cursor  
    FETCH NEXT FROM product_cursor INTO @product  
  
    IF @@FETCH_STATUS <> 0   
        PRINT '         <<None>>'       
  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
  
        SELECT @message = '         ' + @product  
        PRINT @message  
        FETCH NEXT FROM product_cursor INTO @product  
        END  
  
    CLOSE product_cursor  
    DEALLOCATE product_cursor  
        -- Get the next vendor.  
    FETCH NEXT FROM vendor_cursor   
    INTO @vendor_id, @vendor_name  
END   
CLOSE vendor_cursor;  
DEALLOCATE vendor_cursor;  

---Realizar un reporte de tipo cursor que permita recorrer departamento por departamento  
---mostrando el salrio promedio de cada Uno

SELECT*FROM HumanResources.Department;
SELECT*FROM HumanResources.Employee;
SELECT*FROM HumanResources.EmployeePayHistory;
SELECT*FROM HumanResources.EmployeeDepartmentHistory;
SELECT*FROM HumanResources.Shift;

USE AdventureWorks2019;

DECLARE @DepartamentID INT
DECLARE @DepartamentName nvarchar(50)
DECLARE @SalarioPromedio DECIMAL(10,2)

DECLARE departament_cursor CURSOR FOR 
SELECT DepartmentID, Name FROM HumanResources.Department

OPEN departament_cursor
FETCH NEXT FROM departament_cursor INTO @DepartamentID, @DepartamentName

WHILE @@FETCH_STATUS = 0  
BEGIN 
	SELECT @SalarioPromedio=  AVG( Rate* PayFrequency)
	FROM HumanResources.Employee e
	INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID=e.BusinessEntityID AND edh.EndDate IS NULL
	INNER JOIN HumanResources.EmployeePayHistory eph ON eph.BusinessEntityID=e.BusinessEntityID
	WHERE edh.DepartmentID=@DepartamentID

	PRINT 'El Salario Promedio en el Departamento ' + @DepartamentName + ' es: ' + CAST(@SalarioPromedio AS NVARCHAR(50))
	FETCH NEXT FROM departament_cursor INTO @DepartamentID, @DepartamentName
END

CLOSE departament_cursor
DEALLOCATE departament_cursor


---Realizar un reporte de tipo cursor que permita recorrer departamento por departamento  
---mostrando el salario promedio de cada Uno y también listar sus empleados

DECLARE @DepartamentID INT
DECLARE @DepartamentName nvarchar(50)
DECLARE @SalarioPromedio DECIMAL(10,2)
DECLARE @EmployeeID INT
DECLARE @EmployeeNAME nvarchar(50)
DECLARE @message varchar(255)

DECLARE departament_cursor CURSOR FOR 
SELECT DepartmentID, Name FROM HumanResources.Department

OPEN departament_cursor
FETCH NEXT FROM departament_cursor INTO @DepartamentID, @DepartamentName

WHILE @@FETCH_STATUS = 0  
BEGIN 
	SELECT @SalarioPromedio=  AVG( Rate* PayFrequency)
	FROM HumanResources.Employee e
	INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID=e.BusinessEntityID AND edh.EndDate IS NULL
	INNER JOIN HumanResources.EmployeePayHistory eph ON eph.BusinessEntityID=e.BusinessEntityID
	WHERE edh.DepartmentID=@DepartamentID

	PRINT 'El Salario Promedio en el Departamento ' + @DepartamentName + ' es: ' + CAST(@SalarioPromedio AS NVARCHAR(50))
	----
	DECLARE employee_cursor CURSOR FOR 
	SELECT e. BusinessEntityID, CONCAT(p.Title, ' ' , p.FirstName , ' ' , p.MiddleName , ' ' , p.LastName) AS 'Nombres'
	FROM HumanResources.Employee e
	INNER JOIN Person.Person p ON  e.BusinessEntityID=p.BusinessEntityID
	INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID=e.BusinessEntityID AND edh.EndDate IS NULL
	WHERE edh.DepartmentID=@DepartamentID

	OPEN employee_cursor 
	FETCH NEXT FROM employee_cursor INTO @EmployeeID, @EmployeeNAME

	IF @@FETCH_STATUS <> 0   
        PRINT '         <<None>>'       
  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
  
        SELECT @message = '     '+CAST(@EmployeeID AS VARCHAR(20))+' - ' + @EmployeeNAME
        PRINT @message  
        FETCH NEXT FROM employee_cursor INTO @EmployeeID,@EmployeeNAME
        END  
  
    CLOSE employee_cursor  
    DEALLOCATE employee_cursor 

	----
	FETCH NEXT FROM departament_cursor INTO @DepartamentID, @DepartamentName
END

CLOSE departament_cursor
DEALLOCATE departament_cursor


SELECT 
	CONCAT(p.Title, ' ' , p.FirstName , ' ' , p.MiddleName , ' ' , p.LastName) AS 'Nombres',
	e.HireDate
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON  e.BusinessEntityID=p.BusinessEntityID



