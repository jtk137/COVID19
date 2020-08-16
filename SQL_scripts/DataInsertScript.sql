CREATE DATABASE COVID

USE COVID
go
CREATE SCHEMA Analysis

CREATE TABLE Analysis.Continents
	(	ContinentID int not null,
		ContinentName nvarchar(20) not null,
		CONSTRAINT PK_Continent PRIMARY KEY (ContinentID)
	)

CREATE TABLE Analysis.Locations
	(	IsoCode char(3) UNIQUE not null,
		ContinentID int not null,
		CountryName nvarchar(50) not null,
		Population int,
		Area decimal(9,1),
		CONSTRAINT PK_Location PRIMARY KEY (IsoCode),
		CONSTRAINT FK_LocationsContinents FOREIGN KEY (ContinentID)
    	REFERENCES Analysis.Continents(ContinentID) ON DELETE CASCADE
	)

CREATE TABLE Analysis.AgeFactor
	(	AgeFactorID int not null,
		AgeFactorName nvarchar(50) not null,
		CONSTRAINT PK_AgeFactor PRIMARY KEY (AgeFactorID)
	)

CREATE TABLE Analysis.AgeIndex
    (
		AgeIndexID int IDENTITY(1,1),
		IsoCode char(3) not null,
		AgeFactorID int not null,
		AgeIndex decimal(5,2)
		CONSTRAINT PK_AgeIndex PRIMARY KEY (AgeIndexID),
		CONSTRAINT FK_AgeIndexLocation FOREIGN KEY (IsoCode)
		REFERENCES Analysis.Locations(IsoCode) ON DELETE CASCADE,
		CONSTRAINT FK_AgeIndexAgeFactor FOREIGN KEY (AgeFactorID)
		REFERENCES Analysis.AgeFactor(AgeFactorID) ON DELETE CASCADE
    )

GO
CREATE VIEW Analysis.viewAgeIndex
AS
SELECT IsoCode, AgeFactorID, AgeIndex
FROM Analysis.AgeIndex

GO
CREATE TABLE Analysis.HealthcareFactor
	(	HealthcareFactorID int not null,
		HealthcareFactorName nvarchar(50) not null,
		CONSTRAINT PK_HealthcareFactor PRIMARY KEY (HealthcareFactorID)
	)

CREATE TABLE Analysis.HealthcareFactorIndex
    (
		HealthcareFactorIndexID int IDENTITY(1,1),
		IsoCode char(3) not null,
		HealthcareFactorID int not null,
		HealthcareFactorIndex decimal(5,2)
		CONSTRAINT PK_HealthcareFactorIndex PRIMARY KEY (HealthcareFactorIndexID),
		CONSTRAINT FK_HealthcareFactorIndexLocation FOREIGN KEY (IsoCode)
		REFERENCES Analysis.Locations(IsoCode) ON DELETE CASCADE,
		CONSTRAINT FK_HealthcareFactorHealthcareFactorIndex FOREIGN KEY (HealthcareFactorID)
		REFERENCES Analysis.HealthcareFactor(HealthcareFactorID) ON DELETE CASCADE
    )

GO
CREATE VIEW Analysis.viewHealthcareFactorIndex
AS
SELECT IsoCode, HealthcareFactorID, HealthcareFactorIndex
FROM Analysis.HealthcareFactorIndex

GO
CREATE TABLE Analysis.TypeofFood
    
	(TypeOfFoodID int not null,
     TypeOfFoodName nvarchar (50),
     CONSTRAINT PK_TypeofFood PRIMARY KEY (TypeofFoodID)
    )

    
CREATE TABLE Analysis.TypeOfNutritionalFact
    
	(
        TypeOfNutritionalFactID int not null,
		TypeOfNutritionalName nvarchar (20),
		CONSTRAINT PK_TypeOfNutritionalFact PRIMARY KEY (TypeOfNutritionalFactId)
	)

    
CREATE TABLE Analysis.SupplyQuantity
    
	(
       SupplyQuantityID int IDENTITY(1,1),
		IsoCode char(3) not null,
		TypeOfFoodID int not null,
		TypeOfNutritionalFactId int not null,
		SupplyQuantity decimal(5,2),
		CONSTRAINT PK_SupplyQuantity PRIMARY KEY (SupplyQuantityID),
		CONSTRAINT FK_SupplyQuantityLocations FOREIGN KEY (IsoCode)
			REFERENCES Analysis.Locations(IsoCode) ON DELETE CASCADE,
		CONSTRAINT FK_SupplyQuantityTypeofFood FOREIGN KEY (TypeofFoodID)
			REFERENCES Analysis.TypeofFood(TypeofFoodID) ON DELETE CASCADE,
		CONSTRAINT FK_SupplyQuantityTypeofNutritionalFact FOREIGN KEY (TypeOfNutritionalFactId)
			REFERENCES Analysis.TypeOfNutritionalFact(TypeOfNutritionalFactId) ON DELETE CASCADE
    )


GO
CREATE VIEW Analysis.viewSupplyQuantity
AS
SELECT IsoCode, TypeOfFoodID, TypeOfNutritionalFactId, SupplyQuantity
FROM Analysis.SupplyQuantity
 
GO
CREATE TABLE Analysis.CasesAndDeaths
    (
        ReportDate date not null   
        ,IsoCode char(3) not null
        ,Cases int
        ,Deaths smallint
        ,CONSTRAINT PK_CasesAndDeaths PRIMARY KEY (ReportDate,IsoCode)
        ,CONSTRAINT FK_CasesAndDeathsLocations FOREIGN KEY (IsoCode)
        REFERENCES Analysis.Locations(IsoCode) ON DELETE CASCADE
    )

GO
BULK INSERT Analysis.Locations
FROM 'C:\Users\Jakub Koszyk\Desktop\Locations.csv'
WITH
(	FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ';',  --CSV field delimiter
    	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)

BULK INSERT Analysis.Continents
FROM 'C:\Users\Jakub Koszyk\Desktop\Continents.csv'
WITH
(	FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ';',  --CSV field delimiter
    	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)

BULK INSERT Analysis.AgeFactor
FROM 'C:\Users\Jakub Koszyk\Desktop\AgeFactor.csv'
WITH
(	FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ';',  --CSV field delimiter
    	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)

BULK INSERT Analysis.viewAgeIndex
FROM 'C:\Users\Jakub Koszyk\Desktop\AgeIndex.csv'
WITH
(	FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ';',  --CSV field delimiter
    	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)

BULK INSERT Analysis.HealthcareFactor
FROM 'C:\Users\Jakub Koszyk\Desktop\HealthcareFactor.csv'
WITH
(	FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ';',  --CSV field delimiter
    	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)

BULK INSERT Analysis.viewHealthcareFactorIndex
FROM 'C:\Users\Jakub Koszyk\Desktop\HealthcareFactorIndex.csv'
WITH
(	FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ';',  --CSV field delimiter
    	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)

    
BULK INSERT Analysis.viewSupplyQuantity

FROM 'C:\Users\Jakub Koszyk\Desktop\SupplyQuantity.csv'
WITH
(   FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',  
	FIRSTROW = 2,  
	FIELDTERMINATOR = ';',  --CSV field delimiter 
	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)

    

GO
BULK INSERT Analysis.TypeofFood
FROM 'C:\Users\Jakub Koszyk\Desktop\TypesOfFood.csv'
WITH
(   FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',   
	FIRSTROW = 2, 
	FIELDTERMINATOR = ';',  --CSV field delimiter
	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)


GO
BULK INSERT Analysis.TypeOfNutritionalFact
FROM 'C:\Users\Jakub Koszyk\Desktop\TypesOfNutritionalFactor.csv'
WITH
(   FORMAT = 'CSV',
	DATAFILETYPE = 'CHAR',
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',  --CSV field delimiter
	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
)



EXEC sp_configure 'Show Advanced Options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO
 
EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO


create table [Analysis].[import_CasesAndDeaths] 
	(ReportDate date
    ,CountryCode char(3)
    ,Continent varchar(50)
    ,Cases int
	,Deaths smallint)

INSERT INTO [Analysis].[import_CasesAndDeaths] 
select 
    convert(date,dateRep) ReportDate
    ,convert(char(3), countryterritoryCode) CountryCode
    ,convert(varchar(50), continentExp) Continent
    ,convert(int, cases) Cases
    ,convert(smallint, deaths) Deaths

 
from   openrowset('Microsoft.ACE.OLEDB.12.0',
       'Excel 12.0 Xml;HDR=YES;Database=C:\Users\Jakub Koszyk\Downloads\COVID-19-geographic-disbtribution-worldwide.xlsx',
	    'select * from [COVID-19-geographic-disbtributi$]')
where
    1=1
    and convert(date,dateRep)>='2020-02-01'


GO
insert into [Analysis].[CasesAndDeaths]
select [ReportDate], [CountryCode] AS [IsoCode], [Cases], [Deaths] 
from [Analysis].[import_CasesAndDeaths] CAD
join [Analysis].[Locations] L on CAD.[CountryCode]=L.[IsoCode]