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
