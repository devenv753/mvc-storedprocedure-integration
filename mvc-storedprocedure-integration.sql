USE [TEST_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[MakeID]
    @CategoryCode NVARCHAR(2),
    @StrDate DATE,
    @NewCode NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Prefix NVARCHAR(20)
    DECLARE @YearSuffix NVARCHAR(2)
    DECLARE @MaxCode INT

    -- Set prefix and suffix
    SET @Prefix = 'INV'
    SET @YearSuffix = RIGHT(CAST(YEAR(@StrDate) AS NVARCHAR), 2)

    -- Get max code from same category and same year
    SET @MaxCode = (
        SELECT MAX(CAST(SUBSTRING(Code, LEN(@Prefix + '.' + @CategoryCode) + 2, 4) AS INT))
        FROM [dbo].[MyDBTable]
        WHERE 
            CategoryCode = @CategoryCode AND
            RIGHT(Code, 2) = @YearSuffix AND
            YEAR(tDate) = YEAR(@StrDate)
    )

    IF @MaxCode IS NULL
        SET @MaxCode = 0

    SET @MaxCode = @MaxCode + 1

    -- Pad to 4 digits
    DECLARE @PaddedCode NVARCHAR(4)
    SET @PaddedCode = RIGHT('0000' + CAST(@MaxCode AS NVARCHAR), 4)

    -- Construct the final code
    SET @NewCode = @Prefix + '.' + @CategoryCode + '.' + @PaddedCode + '.' + @YearSuffix
END
