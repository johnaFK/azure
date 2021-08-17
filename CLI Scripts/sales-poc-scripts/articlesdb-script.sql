CREATE TABLE [dbo].[Article](
	[Id] [int] NOT NULL IDENTITY,
	[Name] [nchar](300) NOT NULL,
	[Description] [nchar](1000),
	[PublicUnitPrice] [money] NOT NULL,
	[WholesaleUnitPrice] [money] NOT NULL,
 CONSTRAINT [PK_Article] PRIMARY KEY ([Id]));
GO

CREATE TABLE [dbo].[Supplier](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](100) NOT NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY ([Id]));
GO

CREATE TABLE [dbo].[ArticleSupplier](
	[ArticleId] [int] NOT NULL,
	[SupplierId] [int] NOT NULL,
	[IsAvailable] [bit] NOT NULL,
 CONSTRAINT [PK_ArticleSupplier] PRIMARY KEY ([ArticleId], [SupplierId]),
 CONSTRAINT [FK_ArticleSupplier_Article_Id] FOREIGN KEY ([ArticleId])
	REFERENCES [Article] ([Id]) ON DELETE CASCADE,
 CONSTRAINT [FK_ArticleSupplier_Supplier_Id] FOREIGN KEY ([SupplierId])
	REFERENCES [Supplier] ([Id]) ON DELETE CASCADE);
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
CREATE PROCEDURE usp_GetAllArticles 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.Id, a.Name, a.Description, a.PublicUnitPrice, a.WholesaleUnitPrice
	FROM Article AS a INNER JOIN ArticleSupplier AS arsu 
		ON a.Id = arsu.ArticleId
	WHERE arsu.IsAvailable = 1
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
CREATE PROCEDURE usp_GetArticleById
	@Id int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.Id, a.Name, a.Description, a.PublicUnitPrice, a.WholesaleUnitPrice
	FROM Article AS a INNER JOIN ArticleSupplier AS arsu 
		ON a.Id = arsu.ArticleId
	WHERE arsu.IsAvailable = 1
		AND a.Id = @Id
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
CREATE PROCEDURE usp_GetArticleByName 
	@Name varchar(300) = 'a'
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.Id, a.Name, a.Description, a.PublicUnitPrice, a.WholesaleUnitPrice
	FROM Article AS a INNER JOIN ArticleSupplier AS arsu 
		ON a.Id = arsu.ArticleId
	WHERE arsu.IsAvailable = 1
		AND a.Name LIKE '%' + @name + '%'
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
CREATE PROCEDURE usp_DisableSupplierItem 
	@ArticleId int = 0,
	@SupplierId int = 0
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[ArticleSupplier] 
		SET [IsAvailable] = 0
		WHERE ArticleId = @ArticleId AND
			SupplierId = @SupplierId
END
GO

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Wild Caught Fresh Alaskan Halibut Fillet',20.57,19.10);

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Own Honey Wheat Bread',3.02,2.8);

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Snack Pack Chocolate Pudding Cups',5.15,4.85);

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Amish Blue Cheese Crumbles',4.61,4.01);

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Tomato Sauce',1.03,9.8);

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Sweet Treats Vanilla Ice Cream Sandwiches',3.43,3.12);

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Beer 12 oz Bottles',10.02,8.98);

INSERT INTO ArticlesDb.dbo.Article ([Name],[PublicUnitPrice],[WholesaleUnitPrice])
     VALUES ('Crisp Linen Scent Disinfectant Spray',4.61,4.11);
GO

INSERT INTO ArticlesDb.dbo.Supplier ([Name]) VALUES ('H-E-B')
INSERT INTO ArticlesDb.dbo.Supplier ([Name]) VALUES ('Nature''s')
INSERT INTO ArticlesDb.dbo.Supplier ([Name]) VALUES ('Hunt''s')
INSERT INTO ArticlesDb.dbo.Supplier ([Name]) VALUES ('Salemville')
INSERT INTO ArticlesDb.dbo.Supplier ([Name]) VALUES ('Hill Country Fare')
INSERT INTO ArticlesDb.dbo.Supplier ([Name]) VALUES ('Sol')
INSERT INTO ArticlesDb.dbo.Supplier ([Name]) VALUES ('Lysol')
GO

INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (1, 1, 1)
INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (2, 2, 1)
INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (3, 3, 1)
INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (4, 4, 1)
INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (5, 3, 1)
INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (6, 5, 1)
INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (7, 6, 1)
INSERT INTO ArticlesDb.dbo.ArticleSupplier ([ArticleId],[SupplierId],[IsAvailable]) VALUES (8, 7, 1)
GO