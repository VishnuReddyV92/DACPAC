-- Database Deployment Script
-- Deploys all database objects

PRINT 'Starting database deployment...'

-- Create Customers table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Customers')
BEGIN
    CREATE TABLE [dbo].[Customers] (
        [CustomerID] INT IDENTITY (1, 1) NOT NULL,
        [FirstName] NVARCHAR (50) NOT NULL,
        [LastName] NVARCHAR (50) NOT NULL,
        [Email] NVARCHAR (100) NOT NULL,
        [CreatedDate] DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
        [ModifiedDate] DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
        CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
    );
    
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Customers_Email]
        ON [dbo].[Customers]([Email] ASC);
        
    PRINT 'Customers table created successfully'
END
ELSE
    PRINT 'Customers table already exists'

-- Create Orders table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
BEGIN
    CREATE TABLE [dbo].[Orders] (
        [OrderID] INT IDENTITY (1, 1) NOT NULL,
        [CustomerID] INT NOT NULL,
        [OrderDate] DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
        [TotalAmount] DECIMAL (18, 2) NOT NULL,
        [Status] NVARCHAR (20) DEFAULT ('Pending') NOT NULL,
        [CreatedDate] DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
        [ModifiedDate] DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
        CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID] ASC),
        CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([CustomerID])
    );

    CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID]
        ON [dbo].[Orders]([CustomerID] ASC);
        
    PRINT 'Orders table created successfully'
END
ELSE
    PRINT 'Orders table already exists'

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

PRINT 'Database deployment completed successfully!'
