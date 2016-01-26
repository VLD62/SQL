Vladislav


Search Drive

Drive
.
Folder Path
My Drive
CCHellenic
tips
queries.folder
NEW 
Folders and views
My Drive
Shared with me
Google Photos
Recent
Starred
Trash
12 GB of 115 GB used
Upgrade storage
Name
Owner
Last modified
File size
queries
me
Mar 3, 2015me
—

detect fragmentation and rebuild.txt
me
May 17, 2013me
3 KB

Index fragmentation query.txt
me
May 17, 2013me
334 bytes
Text
detect fragmentation and rebuild.txt
Details
Activity
LAST YEAR

Youcreated an item in
Computer • Mar 3, 2015
Google Drive Folder
queries.folder
Text
detect fragmentation and rebuild.txt
No recorded activity before March 3, 2015
Get Drive for PC
All selections cleared

USE [MAP_Report]
GO
/****** Object:  StoredProcedure [dbo].[udp_Optimize_Index]    Script Date: 05/17/2013 11:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================
--Author: Daniel A Penchev
--Created on: 2012-10-24
--Description: Rebuild indexes of specific table on the current DB
--=================================
ALTER procedure [dbo].[udp_Optimize_Index]
	@table varchar(100)
as 
begin

	DECLARE @db varchar(100)
	DECLARE @indexName varchar(500)
	DECLARE @alter varchar(500)
	DECLARE @stat varchar(500)

-- CHECK IF INPUT TABLE EXISTS  
  IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'AND TABLE_NAME LIKE '%'+@table+'%')  
  BEGIN  
   PRINT ''  
   PRINT '/** ERROR: Input table "'+@table+'"was not found in database. Script will be terminated. **/'  
   GOTO _EXIT  
  END  

	SELECT ix.name,
	ps.avg_fragmentation_in_percent,
	ps.fragment_count as ToatalFrags,
	ps.avg_fragment_size_in_pages as FragmentsInPAge,
	ps.page_count as NumPages
	from sys.dm_db_index_physical_stats(DB_ID(),object_id(@table),null,null,'DETAILED') ps
		INNER JOIN sys.indexes ix ON ix.object_id = ps.object_id AND ix.index_id = ps.index_id
	WHERE ps.avg_fragmentation_in_percent > 5


-- Indexes for Reorganize:
	DECLARE smallCur cursor for SELECT distinct ix.name
								from sys.dm_db_index_physical_stats(DB_ID(),object_id(@table),null,null,'DETAILED') ps
									INNER JOIN sys.indexes ix ON ix.object_id = ps.object_id AND ix.index_id = ps.index_id
								WHERE ps.avg_fragmentation_in_percent between 5 AND 30

	OPEN smallCur
	FETCH next from smallCur into @indexName

	WHILE @@FETCH_STATUS = 0
	begin

	select @alter = N'ALTER index ['+@indexName+N'] on '+@table+' reorganize'

	--print @alter

	exec(@alter)
	FETCH next from smallCur into @indexName
	end

	CLOSE smallCur
	DEALLOCATE smallCur

-- Indexes for Rebuild: 

	DECLARE curIX cursor for SELECT distinct ix.name
								from sys.dm_db_index_physical_stats(DB_ID(),object_id(@table),null,null,'DETAILED') ps
									INNER JOIN sys.indexes ix ON ix.object_id = ps.object_id AND ix.index_id = ps.index_id
								WHERE ps.avg_fragmentation_in_percent > 30

	OPEN curIX
	FETCH next from curIX into @indexName

	WHILE @@FETCH_STATUS = 0
	begin

	select @alter = N'ALTER index ['+@indexName+N'] on '+@table+' rebuild'

	--print @alter

	exec(@alter)
	FETCH next from curIX into @indexName
	end

	CLOSE curIX
	DEALLOCATE curIX

--=========== Update Statistcs:
	select @stat = 'UPDATE STATISTICS '+@table
	exec(@stat)
	
	SELECT ix.name,
	ps.avg_fragmentation_in_percent,
	ps.fragment_count as ToatalFrags,
	ps.avg_fragment_size_in_pages as FragmentsInPAge,
	ps.page_count as NumPages
	from sys.dm_db_index_physical_stats(DB_ID(),object_id(@table),null,null,'DETAILED') ps
		INNER JOIN sys.indexes ix ON ix.object_id = ps.object_id AND ix.index_id = ps.index_id
	WHERE ps.avg_fragmentation_in_percent > 5

_EXIT:  
 PRINT ''  
 PRINT '/** Finish time: '+convert(sysname,getdate(),120)+' **/'  
 PRINT '/** COMPLETED **/'
end
