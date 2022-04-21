USE master
GO

SET ANSI_Nulls ON 
GO
SET Quoted_Identifier ON
GO
/*============================================================================================================================
  Creating Database: SalesOrderStore
  ============================================================================================================================*/

-- Remove database if it exists
IF (EXISTS (SELECT * FROM master.dbo.sysdatabases WHERE name = 'SalesOrderStore_DW'))
	BEGIN
		ALTER DATABASE SalesOrderStore_DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE SalesOrderStore_DW;
	END
GO

-- Create database
CREATE DATABASE SalesOrderStore_DW;
GO
/*============================================================================================================================
  Creating Tables
  ============================================================================================================================*/
  
-- Selecting Database: SalesOrderStore
USE SalesOrderStore_DW
GO
drop table if exists [SalesOrderStore_DW].[dbo].[combined_table_with_values]
CREATE TABLE [SalesOrderStore_DW].[dbo].[combined_table_with_values] 
	( 
        ProductQuantity INT NULL,
        OrderDate datetime NULL, 
--		OrderDueDate datetime NULL, 
--		OrderShipDate datetime NULL, 
		OrderTotal DECIMAL(18,4) NULL, 
		OrderDiscountTotal DECIMAL(18,4) NULL DEFAULT 0, 
--		OrderBillingCity INT NULL, 
--		OrderShippingCity INT NULL,
        ProductUnitPrice DECIMAL(18,4) NULL, 
		ProductUnitPriceDiscount DECIMAL(18,4) NULL DEFAULT 0.0,
		ClientName VARCHAR(20) NULL, 
		ProductName VARCHAR(150) NULL, 
		VendorName VARCHAR(50) NULL,
		Category VARCHAR(50) NULL, 
		Subcategory VARCHAR(50) NULL,
		CustomerState VARCHAR(50) NULL,
		VendorCategory VARCHAR(50) NULL,
		WeekdaysToDeliver int NULL,
		CustomerFeedbackRating int NULL,
		EmployeeName VARCHAR(20) NULL
	);

truncate table [SalesOrderStore_DW].[dbo].[combined_table_with_values]

insert into [SalesOrderStore_DW].[dbo].[combined_table_with_values] 
SELECT sop.ProductQuantity AS ProductQuantity, so.OrderDate AS OrderDate, so.OrderTotal AS OrderTotal, so.OrderDiscountTotal AS OrderDiscountTotal, sop.ProductUnitPrice AS ProductUnitPrice, sop.ProductUnitPriceDiscount AS ProductUnitPriceDiscount,CONCAT(c.CustomerFirstName, ' ',c.CustomerLastName) AS ClientName, p.ProductName AS ProductName, v.VendorName AS VendorName, pc.ProductCategoryName AS Category, psc.ProductSubCategoryName AS Subcategory, a.StateProvince AS CustomerState, vc.VendorCategoryName AS VendorCategory, DATEDIFF(dd,so.OrderDate,so.OrderDeliveryDate)+1-DATEDIFF(ww,so.OrderDate,so.OrderDeliveryDate)*2 AS WeekdaysToDeliver, CustomerFeedbackRating AS CustomerFeedbackRating, CONCAT(e.EmployeeFirstName,' ',e.EmployeeLastName) AS EmployeeName
FROM [SalesOrderStore].[dbo].[SalesOrderProducts] sop 
LEFT OUTER JOIN [SalesOrderStore].[dbo].[Products] AS p ON sop.ProductID = p.ProductID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[SalesOrders] AS so ON sop.SalesOrderID = so.SalesOrderID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[Customers] AS c ON so.CustomerID = c.CustomerID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[Vendors] AS v ON p.VendorID = v.VendorID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[VendorCategories] AS vc ON v.VendorCategoryID = vc.VendorCategoryID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[ProductSubCategories] AS psc ON p.ProductSubCategoryID = psc.ProductSubCategoryID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[ProductCategories] AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[Addresses] AS a ON c.CustomerAddressID = a.AddressID
LEFT OUTER JOIN [SalesOrderStore].[dbo].[CustomerFeedbacks] AS cf ON sop.ProductID = cf.ProductID AND c.CustomerID = cf.CustomerID 
LEFT OUTER JOIN [SalesOrderStore].[dbo].[Employees] AS e ON v.RelationshipManagerID = e.EmployeeID

drop table if exists [SalesOrderStore_DW].[dbo].[DimProducts]
CREATE TABLE [SalesOrderStore_DW].[dbo].[DimProducts]
	(
        PKeyProduct INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		ProductName VARCHAR(150) NULL, 
		Subcategory VARCHAR(50) NULL,
		Category VARCHAR(50) NULL
	);

TRUNCATE TABLE [SalesOrderStore_DW].[dbo].[DimProducts] 
INSERT INTO [SalesOrderStore_DW].[dbo].[DimProducts]
SELECT DISTINCT ProductName, Subcategory, Category
FROM [SalesOrderStore_DW].[dbo].[combined_table_with_values]

drop table if exists [SalesOrderStore_DW].[dbo].[DimCustomers]
CREATE TABLE [SalesOrderStore_DW].[dbo].[DimCustomers]
	( 
        PKeyCustomer INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
		CustomerState VARCHAR(25) NULL,  
		ClientName VARCHAR(20) NOT NULL,
	);
TRUNCATE TABLE [SalesOrderStore_DW].[dbo].[DimCustomers]  
INSERT INTO [SalesOrderStore_DW].[dbo].[DimCustomers]  
SELECT DISTINCT CustomerState, ClientName
FROM [SalesOrderStore_DW].[dbo].[combined_table_with_values]

drop table if exists [SalesOrderStore_DW].[dbo].[DimVendors]
CREATE TABLE [SalesOrderStore_DW].[dbo].[DimVendors] 
	( 
		PKeyVendor INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
		VendorName VARCHAR(50) NULL, 
		VendorCategory VARCHAR(20) NULL
	);
TRUNCATE TABLE [SalesOrderStore_DW].[dbo].[DimVendors]   
INSERT INTO [SalesOrderStore_DW].[dbo].[DimVendors]   
SELECT DISTINCT VendorName, VendorCategory
FROM [SalesOrderStore_DW].[dbo].[combined_table_with_values]

drop table if exists [SalesOrderStore_DW].[dbo].[DimEmployees]
CREATE TABLE [SalesOrderStore_DW].[dbo].[DimEmployees] 
	( 
		PKeyEmployee INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
		EmployeeName VARCHAR(20) NULL 
	);

TRUNCATE TABLE [SalesOrderStore_DW].[dbo].[DimEmployees]    
INSERT INTO [SalesOrderStore_DW].[dbo].[DimEmployees]    
SELECT DISTINCT EmployeeName
FROM [SalesOrderStore_DW].[dbo].[combined_table_with_values]

drop table if exists [SalesOrderStore_DW].[dbo].[DimFeedback]
CREATE TABLE [SalesOrderStore_DW].[dbo].[DimFeedback]  
	( 
		PKeyFeedback INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
		FeedbackRating INT NULL,
	);

TRUNCATE TABLE [SalesOrderStore_DW].[dbo].[DimFeedback]     
INSERT INTO [SalesOrderStore_DW].[dbo].[DimFeedback]     
SELECT DISTINCT CustomerFeedbackRating
FROM [SalesOrderStore_DW].[dbo].[combined_table_with_values]

drop table if exists [SalesOrderStore_DW].[dbo].[FactSalesTransactions]
CREATE TABLE [SalesOrderStore_DW].[dbo].[FactSalesTransactions] 
	( 
		PKeyVendor INT NULL, 
		PKeyProduct INT NULL,
		PKeyCustomer INT NULL,
		PKeyEmployee INT NULL,
		OrderDate DATETIME NULL,
		OrderDiscountTotal DECIMAL(18,4) NULL,
		ProductUnitPrice DECIMAL(18,4) NULL,
		WeekdaysToDeliver INT NULL
	);

TRUNCATE TABLE [SalesOrderStore_DW].[dbo].[FactSalesTransactions]     
INSERT INTO [SalesOrderStore_DW].[dbo].[FactSalesTransactions]     
SELECT PkeyVendor, PKeyProduct, PKeyCustomer, PKeyEmployee, OrderDate, OrderDiscountTotal, ProductUnitPrice, WeekdaysToDeliver
FROM [SalesOrderStore_DW].[dbo].[combined_table_with_values] cm, [SalesOrderStore_DW].[dbo].[DimVendors] v, [SalesOrderStore_DW].[dbo].[DimProducts] p, [SalesOrderStore_DW].[dbo].[DimCustomers] c, [SalesOrderStore_DW].[dbo].[DimEmployees] e
WHERE cm.VendorName = v.VendorName AND
cm.ProductName = p.ProductName AND
cm.ClientName = c.ClientName AND
cm.EmployeeName = e.EmployeeName
