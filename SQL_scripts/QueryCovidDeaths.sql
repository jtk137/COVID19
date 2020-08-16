USE COVID

GO
CREATE VIEW Analysis.viewDeathsRunningSum AS
select reportdate, c.isocode, deaths, population,
SUM(deaths) OVER(partition by c.isocode order by reportdate asc) as RunningSUM
from Analysis.CasesAndDeaths C
inner join Analysis.Locations L on C.isocode = L.isocode


GO
CREATE VIEW Analysis.viewDayOfFirstDeathByCountry AS
SELECT 
ROW_NUMBER() OVER(PARTITION BY isocode ORDER BY isocode, ReportDate asc) AS number,
ReportDate, IsoCode, Deaths
FROM Analysis.CasesAndDeaths
WHERE Deaths > 0


GO
CREATE VIEW Analysis.viewDeathsPerMillion AS
select reportdate, isocode, deaths, population, runningSUM, (CONVERT(DECIMAL(10,2), runningSUM)/CONVERT(DECIMAL(12,2), population))*1000000.0 as DeathsPerMillion
from Analysis.viewDEathsRunningSum


GO
CREATE VIEW Analysis.viewDeathsPerMlnMoreThanThirty AS
select reportdate, isocode, deaths, population, runningSUM, DeathsPerMillion, ROW_NUMBER() OVER(PARTITION BY isocode ORDER BY isocode, ReportDate asc) AS numer
from Analysis.viewDeathsPerMillion
where DeathsPerMillion > 30


GO
CREATE VIEW Analysis.viewFirstDayWithDeath AS
select ReportDate, IsoCode 
from Analysis.viewDayOfFirstDeathByCountry
where number = 1  and ReportDate <> '2020-02-01'

GO
CREATE VIEW Analysis.viewFirstDayWithMoreDeaths AS
select ReportDate, IsoCode 
from Analysis.viewDeathsPerMlnMoreThanThirty
where numer = 1 and population > 5000000


GO
SELECT IsoCode, diffdays from(
select T1.IsoCode, DATEDIFF(DAY,T2.ReportDate,T1.ReportDate) as diffdays from
(select ReportDate, IsoCode 
from Analysis.viewFirstDayWithMoreDeaths) T1
left join
(select ReportDate, IsoCode 
from Analysis.viewFirstDayWithDeath) T2 ON T1.IsoCode = T2.IsoCode) T3
where diffdays is not null


