USE COVID

GO
CREATE VIEW Analysis.viewCasesRunningSum AS
select reportdate, c.isocode, cases, population,
SUM(Cases) OVER(partition by c.isocode order by reportdate asc) as RunningSUM
from Analysis.CasesAndDeaths C
inner join Analysis.Locations L on C.isocode = L.isocode


GO
CREATE VIEW Analysis.viewDayOfFirstCaseByCountry AS
SELECT 
ROW_NUMBER() OVER(PARTITION BY isocode ORDER BY isocode, ReportDate asc) AS number,
ReportDate, IsoCode, Cases 
FROM Analysis.CasesAndDeaths
WHERE Cases > 0


GO
CREATE VIEW Analysis.viewCasesPerMillion AS
select reportdate, isocode, cases, population, runningSUM, (CONVERT(DECIMAL(10,2), runningSUM)/CONVERT(DECIMAL(12,2), population))*1000000.0 as CasesPerMillion
from Analysis.viewCasesRunningSum


GO
CREATE VIEW Analysis.viewCasesPerMlnMoreThanHundred AS
select reportdate, isocode, cases, population, runningSUM, CasesPerMillion, ROW_NUMBER() OVER(PARTITION BY isocode ORDER BY isocode, ReportDate asc) AS numer
from Analysis.viewCasesPerMillion
where CasesPerMillion > 100


GO
CREATE VIEW Analysis.viewFirstDayWithCase AS
select ReportDate, IsoCode 
from Analysis.viewDayOfFirstCaseByCountry
where number = 1  and ReportDate <> '2020-02-01'

GO
CREATE VIEW Analysis.viewFirstDayWithMoreCases AS
select ReportDate, IsoCode 
from Analysis.viewCasesPerMlnMoreThanHundred
where numer = 1 and population > 5000000



GO
SELECT IsoCode, diffdays from(
select T1.IsoCode, DATEDIFF(DAY,T2.ReportDate,T1.ReportDate) as diffdays from
(select ReportDate, IsoCode 
from Analysis.viewFirstDayWithMoreCases) T1
left join
(select ReportDate, IsoCode 
from Analysis.viewFirstDayWithCase) T2 ON T1.IsoCode = T2.IsoCode) T3
where diffdays is not null


