CREATE TABLE [dbo].[Customer](
	[Id] [int] NOT NULL IDENTITY,
	[FirstName] [nchar](50) NOT NULL,
	[LastName] [nchar](50) NOT NULL,
	[Nickname] [nchar](25) NOT NULL,
	[Address] [nchar](200),
 CONSTRAINT [PK_Customer] PRIMARY KEY ([Id]));
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
CREATE PROCEDURE usp_GetAllCustomers 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.*
	FROM Customer AS c
	ORDER BY c.LastName
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
CREATE PROCEDURE usp_GetCustomerById
	@Id int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.*
	FROM Customer AS c
	WHERE c.Id = @Id
	ORDER BY c.LastName
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
CREATE PROCEDURE usp_GetCustomerByNickname 
	@Nickname varchar(25) = 'a'
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.*
	FROM Customer AS c
	WHERE c.Nickname LIKE '%' + @Nickname + '%'
	ORDER BY c.LastName
END
GO

USE [CustomerDb]
GO

INSERT INTO CustomerDb.dbo.Customer ([FirstName],[LastName],[Nickname],[Address])
     VALUES('Luis Ignacio','Orozco','Nacho','Dirección 01')
INSERT INTO CustomerDb.dbo.Customer  ([FirstName],[LastName],[Nickname],[Address])
     VALUES('Ricardo','Juarez','Richard','Dirección 02')
INSERT INTO CustomerDb.dbo.Customer  ([FirstName],[LastName],[Nickname],[Address])
     VALUES('Alejandro','Garnica','Alex','Dirección 03')
INSERT INTO CustomerDb.dbo.Customer  ([FirstName],[LastName],[Nickname],[Address])
     VALUES('Johnatan','Flores','Johna','Echeveste')
GO