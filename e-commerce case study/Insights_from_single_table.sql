/*========================================================================================================
  Retrieving Business Insights from a single table
  ========================================================================================================*/
  --Please give me all the details of our past and present vendors
  SELECT * from Vendors
  -- please give me the names of all present and past vendors in descending order
  SELECT vendorname FROM Vendors ORDER BY vendorname desc
  -- please give me the present and past vendors and include their ids, name, phone number and email address
  SELECT VendorID, VendorName, VendorPhoneNumber, VendorEmail
  FROM Vendors
  -- please give me all our customers with their genders, first name, last name, phone number and email. Show the results in descending order by gender, and then in ascending order by first name, and finaly by last name
  SELECT CustomerGender, CustomerFirstName, CustomerLastName, CustomerPhoneNumber, CustomerEmail
  FROM [SalesOrderStore].[dbo].[Customers]
  ORDER BY CustomerGender DESC,CustomerFirstName ASC, CustomerLastName ASC 
  --What is the minimum comission we can get from a vendor from each category if they meet the monthly sales target
  SELECT VendorCategoryName, VendorMonthlyTarget * VendorCommissionRatePercent/100 AS MinimumCommission 
  FROM  VendorCategories
  --please give me a list of 5 sample customers showing their ids, gender, first name
  SELECT TOP 5 CustomerID, CustomerGender, CustomerFirstName
  FROM Customers
  -- Please give me a list of male customers
  SELECT *
  FROM Customers
  WHERE CustomerGender = "Male"
  -- PLease give me a lsit of our customers who are 50 years or older
  SELECT *
  FROM Customers
  WHERE CustomerDateOfBirth < DATEADD(yy, -50, DATEADD(dd,1,DATEDIFF(dd,0,GETDATE())))
  -- PLease give me all the deatils on customer whose first name start with 'Ric'
  SELECT *
  FROM Customers
  WHERE CustomerFirstName LIKE 'Ric%'
  -- Please give me details of customers whos mobile number is not know to us
 SELECT *
 FROM Customers
 WHERE CustomerMobileNumber= NULL
 --Please give me a list of all products for vendor Id's 7 & 8 that can be delivered within the a week of a customers initial order date
 SELECT *
 FROM Products
 WHERE VendorID IN (7,8) AND DaysToDeliver <=7
 --Please give me a list of all products for vendor Id's 7 & 8 that maytake more than a week to delivered after customers initial order date
 SELECT *
 FROM Products
 WHERE VendorID IN (7,8) AND NOT DaysToDeliver <=7
 --Please give me a list of all products for vendor Id's 7 & 8 as well as products from other vendors that may take more than a week to deliver that can be delivered after a customers initial order date
 SELECT *
 FROM Products
 WHERE VendorID IN (7,8) OR DaysToDeliver >7
 --How many products do we have
 SELECT COUNT(*) AS NumberOfProducts
 FROM Products
 --How many products do we have in each sub category
 SELECT ProductSubCategoryID, COUNT(*) AS NumberofProducts
 FROM Products
 GROUP BY ProductSubCategoryID 
 --Please put together a list giving how many sales orders we have recieved each year since our company opened its doors for business & total gross value
 SELECT YEAR(OrderDate) AS YearOfOrder, COUNT(*)AS NumberOfOrders, COUNT(OrderTotal)AS TotalGrossValue 
 FROM SalesOrders
 GROUP BY YEAR(OrderDate)
 --Please put together a list giving how many sales orders we have recieved each month since our company opened its doors for business & total gross value
 SELECT YEAR(OrderDate) AS YearOfOrder, MONTH(OrderDate)AS MonthOfOrder,COUNT(*)AS NumberOfOrders, COUNT(OrderTotal)AS TotalGrossValue 
 FROM SalesOrders
 GROUP BY YEAR(OrderDate), MONTH(OrderDate)
 ORDER BY YearOfOrder, MonthOfOrder
