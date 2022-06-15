CREATE TABLE [dbo].[Article](
	[Id] [int] NOT NULL IDENTITY,
	[Name] [nchar](300) NOT NULL,
    [ReferenceArticleId] [int] NOT NULL,
 CONSTRAINT [PK_Article] PRIMARY KEY ([Id]))
GO

CREATE TABLE [dbo].[Warehouse](
	[Id] [int] NOT NULL IDENTITY,
	[Name] [nchar](50) NOT NULL,
	[Address] [nchar](200) NOT NULL,
 CONSTRAINT [PK_Warehouse] PRIMARY KEY ([Id]))
GO

CREATE TABLE [dbo].[WarehouseStock](
	[WarehouseId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
CONSTRAINT [PK_WarehouseStock] PRIMARY KEY ([WarehouseId], [ArticleId]),
CONSTRAINT [FK_WarehouseStock_Article_Id] FOREIGN KEY ([ArticleId])
    REFERENCES [Article] ([Id]) ON DELETE CASCADE,
CONSTRAINT [FK_WarehouseStock_Warehouse_Id] FOREIGN KEY([WarehouseId])
    REFERENCES [Warehouse] ([Id]) ON DELETE CASCADE)
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
CREATE PROCEDURE usp_GetArticleById
	@Id int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.Id, a.Name, a.ReferenceArticleId
	FROM Article AS a 
	ORDER BY Name
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
CREATE PROCEDURE usp_GetWarehouseById
	@Id int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT w.Id, w.Name, w.Address
	FROM Warehouse AS w 
	ORDER BY Name
END
GO

CREATE TYPE ArticlesIds AS TABLE (ArticleId int)
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
CREATE PROCEDURE usp_GetWarehouseStocksByArticlesId
	@ArticlesId ArticlesIds READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ws.WarehouseId, ws.ArticleId, ws.Quantity
    FROM WarehouseStock AS ws
    WHERE ws.ArticleId IN (SELECT * FROM @ArticlesId)
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
CREATE PROCEDURE usp_GetWarehouseStocks
	@ArticleId int = 0,
    @WarehouseId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ws.WarehouseId, ws.ArticleId, ws.Quantity
    FROM WarehouseStock AS ws
    WHERE ws.ArticleId = @ArticleId AND ws.WarehouseId = @WarehouseId
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
CREATE PROCEDURE usp_UpdateWarehouseStocks
	@ArticleId int = 0,
    @WarehouseId int = 0,
    @Quantity int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[WarehouseStock] 
    SET [Quantity] = @Quantity
    WHERE [WarehouseId] = @WarehouseId AND [ArticleId] = @ArticleId

    SELECT ws.WarehouseId, ws.ArticleId, ws.Quantity
    FROM WarehouseStock AS ws
    WHERE ws.ArticleId = @ArticleId AND ws.WarehouseId = @WarehouseId
END
GO

USE [WarehouseDb]
GO

INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES('Crisp Linen Scent Disinfectant Spray',8);
INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES('Own Honey Wheat Bread',2);
INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES('Sweet Treats Vanilla Ice Cream Sandwiches',6);
INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES('Amish Blue Cheese Crumbles',4);
INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES('Tomato Sauce',5);
INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES('Snack Pack Chocolate Pudding Cups',3);
INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES('Beer 12 oz Bottles',7);
INSERT INTO WarehouseDb.dbo.Article ([Name], [ReferenceArticleId]) VALUES ('Wild Caught Fresh Alaskan Halibut Fillet',1);
GO

INSERT INTO WarehouseDb.dbo.Warehouse ([Name],[Address]) VALUES ('Warehouse 01','Dirección Warehouse 01');
INSERT INTO WarehouseDb.dbo.Warehouse ([Name],[Address]) VALUES ('Warehouse 02','Warehouse 02 Address');
GO

INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (1,1,5)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (1,2,3)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (1,3,10)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (1,4,8)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (1,5,2)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (1,6,4)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (1,7,1)

INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (2,1,1)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (2,2,2)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (2,3,0)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (2,4,3)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (2,5,4)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (2,6,0)
INSERT INTO WarehouseDb.dbo.WarehouseStock ([WarehouseId],[ArticleId],[Quantity]) VALUES (2,7,5)
GO