USE [master]
GO
/****** Object:  Database [wabbajack_dev]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE DATABASE [wabbajack_dev]
    CONTAINMENT = NONE
    ON  PRIMARY
    ( NAME = N'wabbajack_dev', FILENAME = N'/home/tbald/postgresql/wabbajack_dev.mdf' , SIZE = 1712128KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
    LOG ON
    ( NAME = N'wabbajack_dev_log', FILENAME = N'/home/tbald/postgresql/wabbajack_dev_log.ldf' , SIZE = 532480KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
    WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [wabbajack_dev] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
    begin
        EXEC [wabbajack_dev].[dbo].[sp_fulltext_database] @action = 'enable'
    end
GO
ALTER DATABASE [wabbajack_dev] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [wabbajack_dev] SET ANSI_NULLS OFF
GO
ALTER DATABASE [wabbajack_dev] SET ANSI_PADDING OFF
GO
ALTER DATABASE [wabbajack_dev] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [wabbajack_dev] SET ARITHABORT OFF
GO
ALTER DATABASE [wabbajack_dev] SET AUTO_CLOSE ON
GO
ALTER DATABASE [wabbajack_dev] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [wabbajack_dev] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [wabbajack_dev] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [wabbajack_dev] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [wabbajack_dev] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [wabbajack_dev] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [wabbajack_dev] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [wabbajack_dev] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [wabbajack_dev] SET  DISABLE_BROKER
GO
ALTER DATABASE [wabbajack_dev] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [wabbajack_dev] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [wabbajack_dev] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [wabbajack_dev] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [wabbajack_dev] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [wabbajack_dev] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [wabbajack_dev] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [wabbajack_dev] SET RECOVERY FULL
GO
ALTER DATABASE [wabbajack_dev] SET  MULTI_USER
GO
ALTER DATABASE [wabbajack_dev] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [wabbajack_dev] SET DB_CHAINING OFF
GO
ALTER DATABASE [wabbajack_dev] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO
ALTER DATABASE [wabbajack_dev] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO
ALTER DATABASE [wabbajack_dev] SET DELAYED_DURABILITY = DISABLED
GO
ALTER DATABASE [wabbajack_dev] SET QUERY_STORE = OFF
GO
USE [wabbajack_dev]
GO
/****** Object:  User [wabbajack]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE USER [wabbajack] FOR LOGIN [wabbajack] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [wabbajack]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [wabbajack]
GO
/****** Object:  UserDefinedTableType [dbo].[ArchiveContentType]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE TYPE [dbo].[ArchiveContentType] AS TABLE(
                                                   [Parent] [bigint] NOT NULL,
                                                   [Child] [bigint] NOT NULL,
                                                   [Path] [varchar](max) NOT NULL
                                               )
GO
/****** Object:  UserDefinedTableType [dbo].[IndexedFileType]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE TYPE [dbo].[IndexedFileType] AS TABLE(
                                                [Hash] [bigint] NOT NULL,
                                                [Sha256] [binary](32) NOT NULL,
                                                [Sha1] [binary](20) NOT NULL,
                                                [Md5] [binary](16) NOT NULL,
                                                [Crc32] [int] NOT NULL,
                                                [Size] [bigint] NOT NULL
                                            )
GO
/****** Object:  UserDefinedFunction [dbo].[Base64ToLong]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[Base64ToLong]
(
    -- Add the parameters for the function here
    @Input varchar
)
    RETURNS bigint
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar bigint

    -- Add the T-SQL statements to compute the return value here
    SELECT @ResultVar = CAST('string' as varbinary(max)) FOR XML PATH(''), BINARY BASE64

    -- Return the result of the function
    RETURN @ResultVar

END
GO
/****** Object:  UserDefinedFunction [dbo].[MaxMetricDate]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[MaxMetricDate]
(
)
    RETURNS date
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result date

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = max(Timestamp) from dbo.Metrics where MetricsKey is not null

    -- Return the result of the function
    RETURN @Result

END
GO
/****** Object:  UserDefinedFunction [dbo].[MinMetricDate]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[MinMetricDate]
(
)
    RETURNS date
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result date

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = min(Timestamp) from dbo.Metrics WHERE MetricsKey is not null

    -- Return the result of the function
    RETURN @Result

END
GO
/****** Object:  Table [dbo].[ArchiveContent]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArchiveContent](
                                       [Parent] [bigint] NOT NULL,
                                       [Child] [bigint] NOT NULL,
                                       [Path] [varchar](max) NOT NULL,
                                       [PathHash]  AS (hashbytes('SHA2_256',[Path])) PERSISTED NOT NULL,
                                       CONSTRAINT [PK_ArchiveContent] PRIMARY KEY CLUSTERED
                                           (
                                            [Parent] ASC,
                                            [PathHash] ASC
                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[AllArchiveContent]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllArchiveContent]
AS
WITH AllArchiveContent(TopParent, Parent, Path, PathHash, Child, Depth) AS (SELECT        pt.Parent, pt.Parent AS Expr1, pt.Path, pt.PathHash, pt.Child, 1 AS Depth
                                                                            FROM            dbo.ArchiveContent AS pt LEFT OUTER JOIN
                                                                                            dbo.ArchiveContent AS gt ON pt.Parent = gt.Child
                                                                            WHERE        (gt.Child IS NULL)
                                                                            UNION ALL
                                                                            SELECT        pt.TopParent, ct.Parent, ct.Path, ct.PathHash, ct.Child, pt.Depth + 1 AS Expr1
                                                                            FROM            dbo.ArchiveContent AS ct INNER JOIN
                                                                                            AllArchiveContent AS pt ON ct.Parent = pt.Child)
SELECT        TopParent, Parent, Path, PathHash, Child, Depth
FROM            AllArchiveContent AS AllArchiveContent_1
GO
/****** Object:  Table [dbo].[IndexedFile]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndexedFile](
                                    [Hash] [bigint] NOT NULL,
                                    [Sha256] [binary](32) NOT NULL,
                                    [Sha1] [binary](20) NOT NULL,
                                    [Md5] [binary](16) NOT NULL,
                                    [Crc32] [int] NOT NULL,
                                    [Size] [bigint] NOT NULL,
                                    CONSTRAINT [PK_IndexedFile] PRIMARY KEY CLUSTERED
                                        (
                                         [Hash] ASC
                                            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Metrics]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Metrics](
                                [Id] [bigint] IDENTITY(1,1) NOT NULL,
                                [Timestamp] [datetime] NOT NULL,
                                [Action] [varchar](24) NOT NULL,
                                [Subject] [varchar](max) NOT NULL,
                                [MetricsKey] [varchar](64) NULL,
                                [GroupingSubject]  AS (substring([Subject],(0),case when patindex('%[0-9].%',[Subject])=(0) then len([Subject])+(1) else patindex('%[0-9].%',[Subject]) end)),
                                CONSTRAINT [PK_Metrics] PRIMARY KEY CLUSTERED
                                    (
                                     [Id] ASC
                                        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_ArchiveContent_Child]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE NONCLUSTERED INDEX [IX_ArchiveContent_Child] ON [dbo].[ArchiveContent]
    (
     [Child] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_IndexedFile_By_SHA256]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_IndexedFile_By_SHA256] ON [dbo].[IndexedFile]
    (
     [Sha256] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ByAction]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE NONCLUSTERED INDEX [IX_ByAction] ON [dbo].[Metrics]
    (
     [Action] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ByTimestamp]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE NONCLUSTERED INDEX [IX_ByTimestamp] ON [dbo].[Metrics]
    (
     [Timestamp] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MetricsByActionAndKey]    Script Date: 1/30/2020 2:19:27 PM ******/
CREATE NONCLUSTERED INDEX [IX_MetricsByActionAndKey] ON [dbo].[Metrics]
    (
     [Action] ASC,
     [MetricsKey] ASC
        )
    INCLUDE([Subject],[GroupingSubject]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[MergeIndexedFiles]    Script Date: 1/30/2020 2:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MergeIndexedFiles]
    -- Add the parameters for the stored procedure here
    @Files dbo.IndexedFileType READONLY,
    @Contents dbo.ArchiveContentType READONLY
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    MERGE dbo.IndexedFile AS TARGET
    USING @Files as SOURCE
    ON (TARGET.Hash = SOURCE.HASH)
    WHEN NOT MATCHED BY TARGET
        THEN INSERT (Hash, Sha256, Sha1, Md5, Crc32, Size)
             VALUES (Source.Hash, Source.Sha256, Source.Sha1, Source.Md5, Source.Crc32, Source.Size);

    MERGE dbo.ArchiveContent AS TARGET
    USING @Contents as SOURCE
    ON (TARGET.Parent = SOURCE.Parent AND TARGET.PathHash = HASHBYTES('SHA2_256', SOURCE.Path))
    WHEN NOT MATCHED BY TARGET
        THEN INSERT (Parent, Child, Path)
             VALUES (Source.Parent, Source.Child, Source.Path);

    COMMIT;

END
USE [master]
GO
ALTER DATABASE [wabbajack_dev] SET  READ_WRITE
GO
