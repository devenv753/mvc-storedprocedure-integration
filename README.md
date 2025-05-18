# MVC Stored Procedure Integration

This project demonstrates how to generate custom formatted IDs using a SQL Server stored procedure and integrate it with an ASP.NET Core MVC application.

## 📌 Features

- SQL Server Stored Procedure for ID Generation
- ASP.NET Core MVC Integration
- ADO.NET-based procedure call
- Formatted ID structure: `INV.<CategoryCode>.<Serial>.<YearSuffix>`
- Real-time code generation based on user input

## 📐 ID Format Example: INV.A1.0003.25


**Breakdown:**
- `INV` — Prefix
- `A1` — Category code
- `0003` — 4-digit padded serial
- `25` — Last 2 digits of the year (2025)

## 🗄️ SQL Stored Procedure

```sql
ALTER PROCEDURE [dbo].[MakeID]
    @CategoryCode NVARCHAR(2),
    @StrDate DATE,
    @NewCode NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Prefix NVARCHAR(20) = 'INV';
    DECLARE @YearSuffix NVARCHAR(2) = RIGHT(CAST(YEAR(@StrDate) AS NVARCHAR), 2);
    DECLARE @MaxCode INT;

    SET @MaxCode = (
        SELECT MAX(CAST(SUBSTRING(Code, LEN(@Prefix + '.' + @CategoryCode) + 2, 4) AS INT))
        FROM MyDBTable
        WHERE CategoryCode = @CategoryCode
          AND RIGHT(Code, 2) = @YearSuffix
          AND YEAR(tDate) = YEAR(@StrDate)
    );

    SET @MaxCode = ISNULL(@MaxCode, 0) + 1;

    SET @NewCode = @Prefix + '.' + @CategoryCode + '.' +
                   RIGHT('0000' + CAST(@MaxCode AS NVARCHAR), 4) + '.' + @YearSuffix;
END


