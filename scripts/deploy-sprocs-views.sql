-- Deploy Stored Procedures and Views
PRINT 'Deploying stored procedures and views...'

-- Create GetCustomerOrders stored procedure
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'GetCustomerOrders')
    DROP PROCEDURE [dbo].[GetCustomerOrders]
GO

CREATE PROCEDURE [dbo].[GetCustomerOrders]
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        o.Status,
        c.FirstName,
        c.LastName,
        c.Email
    FROM dbo.Orders o
    INNER JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC;
END
GO
PRINT 'GetCustomerOrders stored procedure created successfully'

-- Create vw_CustomerOrderSummary view
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_CustomerOrderSummary')
    DROP VIEW [dbo].[vw_CustomerOrderSummary]
GO

CREATE VIEW [dbo].[vw_CustomerOrderSummary]
AS
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent,
    MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email;
GO
PRINT 'vw_CustomerOrderSummary view created successfully'
