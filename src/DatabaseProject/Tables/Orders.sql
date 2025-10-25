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
GO

CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID]
    ON [dbo].[Orders]([CustomerID] ASC);
