USE master
GO

/*========================================================================================================
  Creating Database: SalesOrderStore
  ========================================================================================================*/

-- Remove database if it exists
IF (EXISTS (SELECT * FROM master.dbo.sysdatabases WHERE name = 'SalesOrderStore'))
	BEGIN
		ALTER DATABASE SalesOrderStore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE SalesOrderStore;
	END
GO

-- Create database
CREATE DATABASE SalesOrderStore;
GO
/*========================================================================================================
  Creating Tables
  ========================================================================================================*/
  
-- Selecting Database: SalesOrderStore
USE SalesOrderStore
GO

-- Create Address table
drop table if exists [SalesOrderStore].[dbo].[Addresses]
CREATE TABLE [SalesOrderStore].[dbo].[Addresses]
(
	[AddressId][int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [StreetAddress] [varchar](100) NOT NULL,
    [City] [varchar](25) NOT NULL,
    [StateProvince] [varchar](25) NULL,
    [Country] [varchar](25) NOT NULL,
    [ZipOrPostalCode] [varchar](20) NULL
)
-- Create CreditCards table
drop table if exists [SalesOrderStore].[dbo].[CreditCards]
CREATE TABLE [SalesOrderStore].[dbo].[CreditCards]
(
	[CreditCardId][int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [CreditCardNumber] [varchar](20) NOT NULL,
    [CardHolderName][varchar](50) NOT NULL,
    [CreditCardType] [varchar](25) NOT NULL,
    [CreditCardExpiryMonth] [int] NOT NULL,
    [CreditCardExpiryYear] [int] NOT NULL
)
-- Create Customers table
drop table if exists [SalesOrderStore].[dbo].[Customers]
CREATE TABLE [SalesOrderStore].[dbo].[Customers]
(
    [CustomerID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [CustomerFirstName] [varchar](20) NOT NULL,
    [CustomerLastName] [varchar](20) NOT NULL,
    [CustomerAddressID] [int] NOT NULL,
    [CustomerPhoneNumber] [varchar](25) NOT NULL,
    [CustomerMobileNumber] [varchar](25) NOT NULL,
    [CustomerEmail] [varchar](50) NOT NULL UNIQUE,
    [CustomerCreditCardID] [int] NOT NULL,
	[CustomerDateOfBirth] [datetime] NULL,
	[CustomerGender] [varchar](15) NULL,
	[CustomerJoinDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[IsActive] BIT NOT NULL DEFAULT 1
)
-- Create EmployeePayments table
drop table if exists [SalesOrderStore].[dbo].[EmployeePayments]
CREATE TABLE [SalesOrderStore].[dbo].[EmployeePayments]
(
	[EmployeePaymentID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[EmployeeID] [int] NOT NULL,
	[EmployeePaymentDate] [datetime] NOT NULL,
	[EmployeePaymentAmount] [decimal](18,4) NOT NULL
)
-- Create Employees table
drop table if exists [SalesOrderStore].[dbo].[Employees]
CREATE TABLE [SalesOrderStore].[dbo].[Employees]
(
    [EmployeeID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[EmployeeFirstName] [varchar](20) NOT NULL,
    [EmployeeLastName] [varchar](20) NOT NULL,
    [EmployeeAddressID] [int] NOT NULL,
    [EmployeePhoneNumber] [varchar](25) NOT NULL,
	[EmployeeMobileNumber] [varchar](25) NOT NULL,
	[EmployeeEmail][varchar](50) NOT NULL,
	[EmployeeDateOfBirth][datetime] NOT NULL,
	[EmployeeGender][varchar](15) NOT NULL,
	[EmployeeCommissionRatePercentage][decimal](4,2) NOT NULL,
	[ManagerID] [int] NULL,
	[IsActive][bit]NOT NULL DEFAULT 1
)
-- Create Logins table
drop table if exists [SalesOrderStore].[dbo].[Logins]
CREATE TABLE [SalesOrderStore].[dbo].[Logins]
(
	[UserId][varchar](50) NOT NULL PRIMARY KEY,
    [Email] [varchar](50) NOT NULL,
    [Password][nvarchar](50) NOT NULL,
    [NoOfFailedAttempts] [INT] NOT NULL DEFAULT 3,
    [ChangePasswordInNextLogin] [bit] NOT NULL DEFAULT 1,
    [IsLocked] [bit] NOT NULL DEFAULT 0,
	[IsActive][bit] NOT NULL DEFAULT 1
)
-- Create ProductCategories table
drop table if exists [SalesOrderStore].[dbo].[ProductCategories]
CREATE TABLE [SalesOrderStore].[dbo].[ProductCategories]
(
	[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductCategoryName] [varchar](50) NOT NULL,
	[ProductCategoryDescription] [varchar](500) NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1
)

-- Create Products table
drop table if exists [SalesOrderStore].[dbo].[Products]
CREATE TABLE [SalesOrderStore].[dbo].[Products]
(
		[ProductID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[ProductName] [varchar](150) NOT NULL,
		[ProductDescription] [varchar](1000) NULL,
		[StandardSalesPrice] [decimal](18,4) NOT NULL,
		[SalesDiscountPercentage] [decimal](4, 2) NOT NULL DEFAULT 0.0,
		[SalesDiscountAmount] [decimal](18,4) NOT NULL DEFAULT 0.0,
		[StockQuantity] [int] NOT NULL DEFAULT 0,
		[OrderedQuantity] [int] NOT NULL DEFAULT 0,
		[DaysToDeliver] [int] NULL,
		[VendorID] [int] NOT NULL,
		[ProductSubCategoryID] [int] NOT NULL,
		[IsActive] [bit] NOT NULL DEFAULT 1
)
-- Create ProductSubCategories table
drop table if exists [SalesOrderStore].[dbo].[ProductSubCategories]
CREATE TABLE [SalesOrderStore].[dbo].[ProductSubCategories]
(
		[ProductSubCategoryID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[ProductSubCategoryName] [varchar](50) NOT NULL,
		[ProductSubCategoryDescription] [varchar](500) NULL,
		[ProductCategoryID] [int] NULL,
		[IsActive] [bit] NOT NULL DEFAULT 1
)
-- Create SalesOrderProducts table with a composit key on the SalesOrderID & ProductID
drop table if exists [SalesOrderStore].[dbo].[SalesOrderProducts]
CREATE TABLE [SalesOrderStore].[dbo].[SalesOrderProducts]
(
	[SalesOrderId][int] NOT NULL,
    [ProductId] [int] NOT NULL,
    [ProductQuantity][int] NOT NULL,
    [ProductUnitPrice] [decimal](18,4) NOT NULL,
    [ProductUnitPriceDiscount] [decimal](18,4) NOT NULL DEFAULT 0.0,
    [ProductShipDate] [datetime] NULL,
	[ProductDeliveryDate][datetime] NULL,
	PRIMARY KEY(SalesOrderId,ProductId)
)
-- Create SalesOrders table
drop table if exists [SalesOrderStore].[dbo].[SalesOrders]
CREATE TABLE [SalesOrderStore].[dbo].[SalesOrders]
(
	[SalesOrderId][int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [OrderDate] [datetime] NOT NULL,
    [OrderDueDate][datetime] NOT NULL,
    [OrderShipDate] [datetime] NULL,
    [OrderDeliveryDate] [datetime] NULL,
    [CustomerId] [int] NOT NULL,
	[OrderTotal][decimal](18,4) NOT NULL,
	[OrderDiscountTotal][decimal](18,4) NOT NULL DEFAULT 0,
	[OrderBillingAddressId][int] NOT NULL,
	[OrderShippingAddressId][int] NOT NULL,
	[OrderCreditCardId][int] NOT NULL
)
-- Create VendorCategories table
drop table if exists [SalesOrderStore].[dbo].[VendorCategories]
CREATE TABLE [SalesOrderStore].[dbo].[VendorCategories]
(
    [VendorCategoryID] [int] NOT NULL PRIMARY KEY,
    [VendorCategoryName] [varchar](20) NOT NULL,
    [VendorCategoryDescription] [varchar](500) NULL,
    [VendorMonthlyTarget] [DECIMAL](18,4) NOT NULL,
    [VendorNumberOfMonthsForPromotion] [int] NOT NULL DEFAULT 3,
	[VendorCommissionRatePercent][decimal](4,2) NOT NULL
)
-- Create VendorPayments table
drop table if exists [SalesOrderStore].[dbo].[VendorPayments]
CREATE TABLE [SalesOrderStore].[dbo].[VendorPayments]
(
	[VendorPaymentID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[VendorID] [int] NOT NULL,
	[VendorPaymentDate] [datetime] NOT NULL,
	[TotalSalesAmount] [decimal](18,4) NOT NULL DEFAULT 0.0,
	[TotalCommissionAmount] [decimal](18,4) NOT NULL DEFAULT 0.0
)
-- Create Vendors table
drop table if exists [SalesOrderStore].[dbo].[Vendors]
CREATE TABLE [SalesOrderStore].[dbo].[Vendors]
(
	[VendorID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[VendorName] [varchar](50) NOT NULL,
	[VendorAddressID] [int] NOT NULL,
	[VendorPhoneNumber] [varchar](25) NOT NULL,
	[VendorFaxNumber] [varchar](25) NULL,
	[VendorEmail] [varchar](50) NOT NULL,
	[VendorCategoryID] [int] NOT NULL,
	[ContactPersonName] [varchar](50) NOT NULL,
	[RelationshipManagerID] [int] NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1
)
-- Create CustomerFeedbacks table with a composit key on the CustomerID & ProductID
drop table if exists [SalesOrderStore].[dbo].[CusromerFeedbacks]
CREATE TABLE [SalesOrderStore].[dbo].[CusromerFeedbacks]
(
    [CustomerID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [CustomerFeedbackRating] [int] NOT NULL,
    [CustomerFeedback] [varchar](300) NULL,
    [FeedbackDate] [datetime] DEFAULT GETDATE(),
	PRIMARY KEY([CustomerID],[ProductID])
)
/*========================================================================================================
  Load Data
  ========================================================================================================*/
INSERT INTO VendorCategories(VendorCategoryID,VendorCategoryName,VendorCategoryDescription,VendorMonthlyTarget,VendorNumberOfMonthsForPromotion,VendorCommissionRatePercent)
VALUES(1,'Regular','Basic category. All new vendors are in this category', 3000, 3,20);

INSERT INTO VendorCategories(VendorCategoryID,VendorCategoryName,VendorMonthlyTarget,VendorCommissionRatePercent)
VALUES(2,'Gold', 5000, 15);

INSERT INTO Addresses(StreetAddress,City,StateProvince,Country,ZipOrPostalCode)
VALUES('475 Flinders Lane','Melbourne', 'Victoria', 'Australia', 3000);
INSERT INTO Addresses(StreetAddress,City,StateProvince,Country,ZipOrPostalCode)
VALUES('9600 Firdale Avenue','Edmonds', 'Washington', 'United States', 98020);

-- Ricky Brown form your regular customers is purchasing 5 different products via your website
/*Adding sales order summary into SalesOrders table*/
INSERT INTO SalesOrders(OrderDate,OrderDueDate,CustomerId,OrderTotal,OrderDiscountTotal,OrderBillingAddressId, OrderShippingAddressId, OrderCreditCardId)
VALUES('2015-01-01', '2015-01-07', 1, 144.00, 60.00, 1,1,1);

/*Assigning previously added identity number into @SalesOrderID variable*/
DECLARE @SalesOrderID INT;
SELECT @SalesOrderID=SCOPE_IDENTITY();

/* Adding products details of the sales order into SalesOrderProduct table */
INSERT INTO SalesOrderProducts(SalesOrderId, ProductId, ProductQuantity, ProductUnitPrice, ProductUnitPriceDiscount)
VALUES (@SalesOrderID,1,2,310.00, 20.00);
INSERT INTO SalesOrderProducts(SalesOrderId, ProductId, ProductQuantity, ProductUnitPrice, ProductUnitPriceDiscount)
VALUES (@SalesOrderID,37,1,300.00, 20.00);
INSERT INTO SalesOrderProducts(SalesOrderId, ProductId, ProductQuantity, ProductUnitPrice, ProductUnitPriceDiscount)
VALUES (@SalesOrderID,2,3,1000.00, 0.00);
INSERT INTO SalesOrderProducts(SalesOrderId, ProductId, ProductQuantity, ProductUnitPrice, ProductUnitPriceDiscount)
VALUES (@SalesOrderID,33,5,20.00, 0.00);
INSERT INTO SalesOrderProducts(SalesOrderId, ProductId, ProductQuantity, ProductUnitPrice, ProductUnitPriceDiscount)
VALUES (@SalesOrderID,53,1,120.00, 0.00);

SELECT * FROM SalesOrders;
SELECT * FROM SalesOrderProducts;

UPDATE VendorCategories SET VendorCategoryName = 'Common Category'
UPDATE VendorCategories SET VendorMonthlyTarget=2000,VendorCommissionRatePercent=12.50
UPDATE VendorCategories SET VendorMonthlyTarget = VendorMonthlyTarget * 1.2, VendorCategoryDescription=VendorCategoryName

--the above updates changes values in field, if you want to set them back as per business problem 1 you can add a where clause 
UPDATE VendorCategories
SET VendorCategoryName='Regular', VendorMonthlyTarget=3000, VendorCommissionRatePercent=20,VendorCategoryDescription='Basic category. All new vendors are in this category'
WHERE VendorCategoryID=1;

UPDATE VendorCategories
SET VendorCategoryName='Gold', VendorMonthlyTarget=50000, VendorCommissionRatePercent=15
WHERE VendorCategoryID=2;

/*Modify OrderDeliveryDate to 6 Jan 2015 for SalesOrderID=1 */
UPDATE SalesOrders SET OrderDeliveryDate='2015-01-06'
WHERE SalesOrderId=1;
/*Modify ProductDeliveryDate to 6 Jan 2015 for SalesOrderID=1 */
UPDATE SalesOrderProducts SET ProductDeliveryDate='2015-01-06'
WHERE SalesOrderId=1;

--if the database has got large and you have archived the data for salesID1 from both the Sales Order & SalesOrderProduct tables
/*Remove order summary from SalesOrders table for SalesOrderID1*/
DELETE FROM SalesOrders WHERE SalesOrderId=1;
/*Remove order summary from SalesOrderProducts table for SalesOrderID1*/
DELETE FROM SalesOrderProducts WHERE SalesOrderId=1;

--an new employee named Tracy Moore has joined the marketing department
/* Adding employee's address details into Addresses table */
INSERT INTO Addresses (StreetAddress, City, StateProvince, Country, ZipOrPostalCode)
VALUES		('8888 Flinders Street', 'Brisbane', 'Queensland', 'Australia', '4000');

/* Assigning previously added identity number into @AddressID variable */
DECLARE @AddressID INT;
SELECT @AddressID = SCOPE_IDENTITY();

/* Adding employee's general details into Employees table */
INSERT INTO	Employees(EmployeeFirstName, EmployeeLastName, EmployeeAddressID, EmployeePhoneNumber, EmployeeMobileNumber, EmployeeEmail, EmployeeDateOfBirth, EmployeeGender, EmployeeCommissionRatePercentage)
VALUES		('Tracey', 'Moore', @AddressID, '+61 3 222222222', '+61 4222222222', 'TraceyMoore@SaleOnYourOwn.com', '1980-01-01', 'Female', 25);

/* Adding employee's login details into Logins table */
INSERT INTO	Logins(UserID, Password, ChangePasswordInNextLogin, Email)
VALUES		('TraceyMoore', 'Welcome123', 1, 'TraceyMoore@SaleOnYourOwn.com');

-- you have been asked to make some changes to Tracey Moore's employee accounts because she got married
UPDATE	Employees
	SET EmployeeLastName = 'William'
WHERE EmployeeEmail = 'TraceyMoore@SaleOnYourOwn.com';

--Tracy is no longer works at the company so you would like to remove her from the database
DELETE FROM	Employees
WHERE EmployeeEmail = 'TraceyMoore@SaleOnYourOwn.com';

/*========================================================================================================
  Referential Integrity
  ========================================================================================================*/
/*in the above insert we inserted details into the sales table but didn't have a customer in the customer table
We can modify the foreign key to give an error if the record doesnt exist in the customer table */
ALTER TABLE SalesOrders
ADD CONSTRAINT FK_SalesOrders_Customers FOREIGN KEY(CustomerID)REFERENCES Customers(CustomerID);
