CREATE TABLE [dbo].[Article](
	[Id] [int] NOT NULL IDENTITY,
	[Name] [nchar](300) NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ReferenceArticleId] [int] NOT NULL,
 CONSTRAINT [PK_Article] PRIMARY KEY ([Id])); 
GO

CREATE TABLE [dbo].[Customer](
	[Id] [int] NOT NULL IDENTITY,
	[FullName] [nchar](100) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY ([Id])); 
GO

CREATE TABLE [dbo].[OrderStatus](
	[Id] [int] NOT NULL IDENTITY,
	[Name] [nvarchar](30) NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
CONSTRAINT [PK_OrderStatus] PRIMARY KEY ([Id]));
GO

CREATE TABLE [dbo].[Order](
	[Id] [int] NOT NULL IDENTITY,
	[OrderDate] [datetime] NOT NULL,
	[Subtotal] [money] NOT NULL,
	[Taxes] [money] NOT NULL,
	[Total] [money] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[OrderStatusId] [int] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY ([Id]),
 CONSTRAINT [FK_Order_Customer_Id] FOREIGN KEY ([CustomerId])
	REFERENCES [Customer] ([Id]) ON DELETE CASCADE,
 CONSTRAINT [FK_Order_OrderStatus_Id] FOREIGN KEY ([OrderStatusId])
	REFERENCES [OrderStatus] ([Id]) ON DELETE CASCADE); 
GO

CREATE TABLE [dbo].[OrderDetail](
	[OrderId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[SalePrice] [money] NOT NULL,
	[Discount] [money] NOT NULL,
	[Subtotal] [money] NOT NULL,
CONSTRAINT [PK_OrderDetail] PRIMARY KEY ([OrderId], [ArticleId]),
CONSTRAINT [FK_OrderDetail_Order_Id] FOREIGN KEY ([OrderId])
	REFERENCES [Order] ([Id]) ON DELETE CASCADE,
CONSTRAINT [FK_OrderDetail_Article_Id] FOREIGN KEY ([ArticleId])
	REFERENCES [Article] ([Id]) ON DELETE CASCADE);
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_CreateOrder 
    @OrderDate datetime,
	@Subtotal money = 0,
	@Taxes money = 0,
	@Total money = 0,
	@CustomerId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @OrderStatusId int
    SET @OrderStatusId = 
        (SELECT so.Id 
        FROM OrdersDb.dbo.OrderStatus AS so 
        WHERE so.Name LIKE '%Pending%')

	INSERT INTO [dbo].[Order] ([OrderDate],[Subtotal],[Taxes],[Total],[CustomerId], [OrderStatusId])
		VALUES (@OrderDate, @Subtotal, @Taxes, @Total, @CustomerId, @OrderStatusId)

	DECLARE @Id int
	SET @Id = SCOPE_IDENTITY()

	SELECT * FROM [dbo].[Order] WHERE Id = @Id
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_CreateOrderDetail 
	@OrderId int = 0,
	@ArticleId int = 0,
	@Quantity int = 0,
	@SalePrice money = 0,
	@Discount money = 0,
	@Subtotal money = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[OrderDetail]
           ([OrderId]
           ,[ArticleId]
           ,[Quantity]
           ,[SalePrice]
           ,[Discount]
           ,[Subtotal])
     VALUES
           (@OrderId
           ,@ArticleId
           ,@Quantity
           ,@SalePrice
           ,@Discount
           ,@Subtotal)
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_GetOrdersByCustomerId 
	@CustomerId int = 0
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT o.Id, o.OrderDate, o.Subtotal, o.Taxes, o.Total, o.CustomerId, o.OrderStatusId
	FROM [dbo].[Order] AS o
	WHERE o.CustomerId = @CustomerId
	ORDER BY o.OrderDate DESC
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_GetOrderById 
	@Id int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT o.Id, o.OrderDate, o.Subtotal, o.Taxes, o.Total, o.CustomerId, o.OrderStatusId
	FROM [dbo].[Order] AS o
	WHERE o.Id = @Id
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_GetOrderDetailsByOrderId    
	@OrderId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT od.OrderId, od.ArticleId, od.Quantity, od.SalePrice, od.Discount, od.Subtotal
	FROM [dbo].[OrderDetail] AS od
	WHERE od.OrderId = @OrderId
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_GetOrderStatusById 
	@Id int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT os.Id, os.Name, os.Description
	FROM [dbo].[OrderStatus] AS os
	WHERE os.Id = @Id
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_CancelOrder 
	@OrderId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[Order]
	SET [OrderStatusId] = 
		(SELECT so.Id 
		FROM OrdersDb.dbo.OrderStatus AS so 
		WHERE so.Name LIKE '%Cancelled%')
	WHERE Id = @OrderId

    SELECT o.Id, o.OrderDate, o.Subtotal, o.Taxes, o.Total, o.CustomerId, o.OrderStatusId
	FROM [dbo].[Order] AS o
	WHERE o.Id = @OrderId
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_GetOrdersByReferenceArticleId 
	@ReferenceArticleId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT o.[Id], o.[OrderDate], o.[Subtotal], o.[Taxes], o.[Total], o.[CustomerId], o.[OrderStatusId]
    FROM [dbo].[Order] AS o
    WHERE o.[Id] IN (
        SELECT od.[OrderId]
        FROM [dbo].[OrderDetail] AS od
        WHERE od.[ArticleId] = (
            SELECT art.[Id]
            FROM [dbo].[Article] AS art
            WHERE art.[ReferenceArticleId] = @ReferenceArticleId
        )
    )
END
GO

USE [OrdersDb]
GO

INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Sweet Treats Vanilla Ice Cream Sandwiches',3.43,6);
INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Beer 12 oz Bottles',10.02,7);
INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Amish Blue Cheese Crumbles',4.61,4);
INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Own Honey Wheat Bread',3.02,2);
INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Wild Caught Fresh Alaskan Halibut Fillet',20.57,1);
INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Snack Pack Chocolate Pudding Cups',5.15,3);
INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Crisp Linen Scent Disinfectant Spray',4.61,8);
INSERT INTO OrdersDb.dbo.Article ([Name],[UnitPrice],[ReferenceArticleId]) VALUES ('Tomato Sauce',1.03,5);
GO

INSERT INTO OrdersDb.dbo.Customer([FullName]) VALUES ('Luis Ignacio Orozco')
INSERT INTO OrdersDb.dbo.Customer([FullName]) VALUES ('Ricardo Juarez')
INSERT INTO OrdersDb.dbo.Customer([FullName]) VALUES ('Alejandro Garnica')
INSERT INTO OrdersDb.dbo.Customer([FullName]) VALUES ('Johnatan Flores')
GO

INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Pending','Customer started the checkout process but did not complete it');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Awaiting Payment','Customer has completed the checkout process, but payment has yet to be confirmed');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Awaiting Fulfillment','Customer has completed the checkout process and payment has been confirmed.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Awaiting Shipment',' Order has been pulled and packaged and is awaiting collection from a shipping provider.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Awaiting Pickup','Order has been packaged and is awaiting customer pickup from a seller-specified location.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Partially Shipped','Only some items in the order have been shipped.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Completed','Order has been shipped/picked up, and receipt is confirmed.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Shipped','Order has been shipped, but receipt has not been confirmed.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Cancelled','Seller has cancelled an order, due to a stock inconsistency or other reasons.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Declined','Seller has marked the order as declined.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Disputed','Customer has initiated a dispute resolution process for the PayPal transaction that paid for the order or the seller has marked the order as a fraudulent order.');
INSERT INTO OrdersDb.dbo.OrderStatus ([Name],[Description]) VALUES ('Manual Verification Required','Order on hold while some aspect, such as tax-exempt documentation, is manually confirmed.');