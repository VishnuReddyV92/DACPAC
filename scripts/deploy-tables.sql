-- Deploy Tables
PRINT 'Deploying tables...'

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
