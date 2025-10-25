CREATE TABLE [dbo].[Customers] (
    [CustomerID] INT IDENTITY (1, 1) NOT NULL,
    [FirstName] NVARCHAR (50) NOT NULL,
    [LastName] NVARCHAR (50) NOT NULL,
    [Email] NVARCHAR (100) NOT NULL,
    [CreatedDate] DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
    [ModifiedDate] DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Customers_Email]
    ON [dbo].[Customers]([Email] ASC);
