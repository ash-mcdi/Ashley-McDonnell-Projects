/*============================================================================================================================
  Creating constraints & indexes
  ============================================================================================================================*/

ALTER TABLE CustomerFeedbacks  WITH CHECK ADD  CONSTRAINT FK_CustomerFeedback_Customers FOREIGN KEY(CustomerID) REFERENCES Customers (CustomerID)
ALTER TABLE CustomerFeedbacks CHECK CONSTRAINT FK_CustomerFeedback_Customers

ALTER TABLE CustomerFeedbacks  WITH CHECK ADD  CONSTRAINT FK_CustomerFeedback_Products FOREIGN KEY(ProductID) REFERENCES Products (ProductID)

ALTER TABLE CustomerFeedbacks CHECK CONSTRAINT FK_CustomerFeedback_Products

CREATE UNIQUE NONCLUSTERED INDEX Idx_Logins_Email ON Logins (Email asc);

ALTER TABLE Customers  WITH CHECK ADD  CONSTRAINT FK_Customers_Addresses FOREIGN KEY(CustomerAddressID) REFERENCES Addresses (AddressID)
ALTER TABLE Customers CHECK CONSTRAINT FK_Customers_Addresses

ALTER TABLE Customers  WITH CHECK ADD  CONSTRAINT FK_Customers_CreditCards FOREIGN KEY(CustomerCreditCardID) REFERENCES CreditCards (CreditCardID)
ALTER TABLE Customers CHECK CONSTRAINT FK_Customers_CreditCards

ALTER TABLE Customers  WITH CHECK ADD  CONSTRAINT FK_Customers_Logins FOREIGN KEY(CustomerEmail) REFERENCES Logins (Email)
ALTER TABLE Customers CHECK CONSTRAINT FK_Customers_Logins

ALTER TABLE EmployeePayments  WITH CHECK ADD  CONSTRAINT FK_EmployeePayments_Employees FOREIGN KEY(EmployeeID) REFERENCES Employees (EmployeeID)
ALTER TABLE EmployeePayments CHECK CONSTRAINT FK_EmployeePayments_Employees

ALTER TABLE Employees  WITH CHECK ADD  CONSTRAINT FK_Employees_Addresses FOREIGN KEY(EmployeeAddressID) REFERENCES Addresses (AddressID)
ALTER TABLE Employees CHECK CONSTRAINT FK_Employees_Addresses

ALTER TABLE Employees  WITH CHECK ADD  CONSTRAINT FK_Employees_Logins FOREIGN KEY(EmployeeEmail) REFERENCES Logins (Email)
ALTER TABLE Employees CHECK CONSTRAINT FK_Employees_Logins

ALTER TABLE Products  WITH CHECK ADD  CONSTRAINT FK_Products_ProductSubCategories FOREIGN KEY(ProductSubCategoryID) REFERENCES ProductSubCategories (ProductSubCategoryID)
ALTER TABLE Products CHECK CONSTRAINT FK_Products_ProductSubCategories

ALTER TABLE ProductSubCategories  WITH CHECK ADD  CONSTRAINT FK_ProductSubCategories_ProductCategories FOREIGN KEY(ProductCategoryID) REFERENCES ProductCategories (ProductCategoryID)
ALTER TABLE ProductSubCategories CHECK CONSTRAINT FK_ProductSubCategories_ProductCategories

ALTER TABLE SalesOrders  WITH CHECK ADD  CONSTRAINT FK_SalesOrders_Customers FOREIGN KEY(CustomerID) REFERENCES Customers (CustomerID)
ALTER TABLE SalesOrders CHECK CONSTRAINT FK_SalesOrders_Customers

ALTER TABLE SalesOrderProducts  WITH CHECK ADD  CONSTRAINT FK_SalesOrderProducts_Products FOREIGN KEY(ProductID) REFERENCES Products (ProductID)
ALTER TABLE SalesOrderProducts CHECK CONSTRAINT FK_SalesOrderProducts_Products

ALTER TABLE SalesOrderProducts  WITH CHECK ADD  CONSTRAINT FK_SalesOrderProducts_SalesOrders FOREIGN KEY(SalesOrderID) REFERENCES SalesOrders (SalesOrderID)
ALTER TABLE SalesOrderProducts CHECK CONSTRAINT FK_SalesOrderProducts_SalesOrders

ALTER TABLE VendorPayments  WITH CHECK ADD  CONSTRAINT FK_VendorPayments_Vendors FOREIGN KEY(VendorID) REFERENCES Vendors (VendorID)
ALTER TABLE VendorPayments CHECK CONSTRAINT FK_VendorPayments_Vendors

ALTER TABLE Vendors  WITH CHECK ADD  CONSTRAINT FK_Vendors_Addresses FOREIGN KEY(VendorAddressID) REFERENCES Addresses (AddressID)
ALTER TABLE Vendors CHECK CONSTRAINT FK_Vendors_Addresses

ALTER TABLE Vendors  WITH CHECK ADD  CONSTRAINT FK_Vendors_Employees FOREIGN KEY(RelationshipManagerID) REFERENCES Employees (EmployeeID)
ALTER TABLE Vendors CHECK CONSTRAINT FK_Vendors_Employees

ALTER TABLE Vendors  WITH CHECK ADD  CONSTRAINT FK_Vendors_Logins FOREIGN KEY(VendorEmail) REFERENCES Logins (Email)
ALTER TABLE Vendors CHECK CONSTRAINT FK_Vendors_Logins

ALTER TABLE Vendors  WITH CHECK ADD  CONSTRAINT FK_Vendors_VendorCategories FOREIGN KEY(VendorCategoryID) REFERENCES VendorCategories (VendorCategoryID)
ALTER TABLE Vendors CHECK CONSTRAINT FK_Vendors_VendorCategories

ALTER TABLE Products  WITH CHECK ADD  CONSTRAINT FK_Products_Vendors FOREIGN KEY(VendorID) REFERENCES Vendors (VendorID)
ALTER TABLE Products CHECK CONSTRAINT FK_Products_Vendors
GO
