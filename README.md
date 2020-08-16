# COVID19
COVID-19 pandemic analysis in terms of health factors

Analyzing risk factors impact on amount of infections and deaths of COVID-19 based on country


DATA SOURCES

Covid-19 dataset is coming from https://github.com/owid/covid-19-data. I altered the data to suit our research therefore some columns and rows are excluded. Data on confirmed cases and deaths in this dataset comes from https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide. Data on ECDC is updated daily but it is important to remember that data represented may not show the actual amount of confirmed cases, this is because of lack of testingor false data provided by authorities. Data on nutrition related factors comes from https://www.kaggle.com/mariaren/covid19-healthy-diet-dataset. 


TOOLS

-SQL Server Management Studio: relation database creation and management
-Power BI: visualtizations of data
-Visual Studio: Tabular Model


OVERVIEW

Data was loaded into the database from CSV files using a script: DataInsertScript.sql.
Data values needed for the visualization were obtained from the scripts: QueryCovidCases.sql and QueryCovidDeaths.sql.
Visualizations were made in the Power BI.
The database schema and figures are in the "Screenshots" folder.


CONCLUSIONS

First, it has been noticed that the number of COVID-19 cases per country's population is declining as calories from oilcrops increase. Second, in countries where animal fat consumption is higher, the rate of increase in COVID-19 incidence has been found to be higher. Third, it was noted that countries with a higher proportion of people over the age of 70 had a faster death rate of 30 per million inhabitants. Fourth, in continents with less access to handwashing facilities, the death rate is higher in relation to the number of cases of the cases od COVID-19, but the case progresses more slowly, possibly due to differences in the diets of the societies.
