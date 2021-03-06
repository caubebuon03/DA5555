USE [BanOto]
GO
/****** Object:  Table [dbo].[chi_tiet_hoa_don]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chi_tiet_hoa_don](
	[ma_chi_tiet] [varchar](50) NOT NULL,
	[ma_hoa_don] [varchar](50) NULL,
	[item_id] [varchar](50) NULL,
	[so_luong] [int] NULL,
 CONSTRAINT [PK_chi_tiet_hoa_don] PRIMARY KEY CLUSTERED 
(
	[ma_chi_tiet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customer]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer](
	[customer_email] [varchar](100) NOT NULL,
	[customer_password] [varchar](150) NULL,
 CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED 
(
	[customer_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hoa_don]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hoa_don](
	[ma_hoa_don] [varchar](50) NOT NULL,
	[ho_ten] [nvarchar](150) NULL,
	[dia_chi] [nvarchar](250) NULL,
 CONSTRAINT [PK_hoa_don] PRIMARY KEY CLUSTERED 
(
	[ma_hoa_don] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[item]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[item](
	[item_id] [varchar](50) NOT NULL,
	[item_group_id] [varchar](50) NULL,
	[item_name] [nvarchar](150) NULL,
	[item_image] [varchar](250) NULL,
	[item_price] [float] NULL,
 CONSTRAINT [PK_item] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[item_group]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[item_group](
	[parent_item_group_id] [varchar](50) NULL,
	[item_group_id] [varchar](50) NOT NULL,
	[item_group_name] [nvarchar](250) NULL,
	[seq_num] [smallint] NULL,
	[url] [varchar](150) NULL,
 CONSTRAINT [PK_item_group] PRIMARY KEY CLUSTERED 
(
	[item_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_customer_create]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
create PROCEDURE [dbo].[sp_customer_create]
(@customer_email              VARCHAR(100), 
 @customer_password          VARCHAR(150)  
)
AS
    BEGIN
      INSERT INTO customer
                (customer_email, 
                 customer_password)
                VALUES
                (@customer_email, 
                 @customer_password);
        SELECT '';
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_hoa_don_create]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_hoa_don_create]
(@ma_hoa_don              VARCHAR(50), 
 @ho_ten          NVARCHAR(150), 
 @dia_chi          NVARCHAR(250),  
 @listjson_chitiet NVARCHAR(MAX)
)
AS
    BEGIN
        INSERT INTO hoa_don
                (ma_hoa_don, 
                 ho_ten, 
                 dia_chi               
                )
                VALUES
                (@ma_hoa_don, 
                 @ho_ten, 
                 @dia_chi
                );
                IF(@listjson_chitiet IS NOT NULL)
                    BEGIN
                        INSERT INTO chi_tiet_hoa_don
                        (ma_chi_tiet, 
                         ma_hoa_don, 
                         item_id, 
                         so_luong                       
                        )
                               SELECT JSON_VALUE(p.value, '$.ma_chi_tiet'), 
                                      @ma_hoa_don, 
                                      JSON_VALUE(p.value, '$.item_id'), 
                                      JSON_VALUE(p.value, '$.so_luong')    
                               FROM OPENJSON(@listjson_chitiet) AS p;
                END;
        SELECT '';
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_item_all]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
create PROCEDURE [dbo].[sp_item_all]
AS
    BEGIN
        SELECT item.item_id, 
               item.item_group_id, 
               item.item_image, 
			   item.item_name, 
			   item.item_price                         
        FROM item 
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_item_create]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
create PROCEDURE [dbo].[sp_item_create]
(@item_id             VARCHAR(50), 
 @item_group_id       VARCHAR(50), 
 @item_image          VARCHAR(250), 
 @item_name           NVARCHAR(150), 
 @item_price          float  
)
AS
    BEGIN
      INSERT INTO item
                (item_id, 
                 item_group_id, 
                 item_image, 
                 item_name, 
                 item_price                 
                )
                VALUES
                (@item_id, 
                 @item_group_id, 
                 @item_image, 
                 @item_name, 
                 @item_price 
                );
        SELECT '';
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_item_get_by_id]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[sp_item_get_by_id](@item_id VARCHAR(50))
AS
    BEGIN
        SELECT item.item_id, 
               item.item_group_id, 
               item.item_image, 
			   item.item_name, 
			   item.item_price                         
        FROM item
      where  item.item_id = @item_id;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_item_group_get_data]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_item_group_get_data]
AS
    BEGIN
        SELECT item_group.parent_item_group_id, 
               item_group.item_group_id, 
               item_group.item_group_name, 
               item_group.seq_num,
			   item_group.url
        FROM item_group
        ORDER BY item_group.seq_num;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_item_search]    Script Date: 14/10/2020 20:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [dbo].[sp_item_search] (@page_index  INT, 
                                       @page_size   INT,
									   @item_group_id Nvarchar(50))
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
                SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY item_name ASC)) AS RowNumber, 
                              i.item_id, 
                              i.item_group_id, 
                              i.item_name , 
                              i.item_image, 
                              i.item_price
                        INTO #Results1
                        FROM [item] AS i
					    WHERE i.item_group_id = @item_group_id;                   
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results1;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results1
                        WHERE ROWNUMBER BETWEEN(@page_index - 1) * @page_size + 1 AND(((@page_index - 1) * @page_size + 1) + @page_size) - 1
                              OR @page_index = -1;
                        DROP TABLE #Results1; 
            END;
            ELSE
            BEGIN
                SET NOCOUNT ON;
                         SELECT(ROW_NUMBER() OVER(
                               ORDER BY item_name ASC)) AS RowNumber, 
                              i.item_id, 
                              i.item_group_id, 
                              i.item_name , 
                              i.item_image, 
                              i.item_price
                        INTO #Results2
                        FROM [item] AS i
						WHERE i.item_group_id = @item_group_id;  
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results2;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results2;
                        DROP TABLE #Results2;
        END;
    END;
GO
