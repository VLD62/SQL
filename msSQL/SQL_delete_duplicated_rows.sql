USE ReconciliationDB
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[DEL_DUPL_RECORDS]
AS
BEGIN
WHILE EXISTS (SELECT     CollectionName
                                   FROM         (SELECT     CollectionName, COUNT(*) AS Expr1
                                                          FROM          eFlow_AuditCollections AS eFlow_AuditCollections_1
                                                          GROUP BY CollectionName) AS CollectionName_1
                                   WHERE     (Expr1 > 1)) BEGIN DELETE TOP (1)
FROM         eFlow_AuditCollections
WHERE     (CollectionName IN
                          (SELECT     CollectionName
                            FROM          (SELECT     CollectionName, COUNT(*) AS Expr1
                                                    FROM          eFlow_AuditCollections AS eFlow_AuditCollections_1
                                                    GROUP BY CollectionName) AS CollectionName_1
                            WHERE      (Expr1 > 1))) END
END

GO

