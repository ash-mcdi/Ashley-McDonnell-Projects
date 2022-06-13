--Data source https://ourworldindata.org/covid-deaths

--Import the data into MS SQL using SSIS

--Aggregated by country
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  ISNULL(Max((total_cases/population))*100, 0 ) as PercentPopulationInfected, ISNULL(SUM(new_cases),1) as total_cases, ISNULL(SUM(cast(new_deaths as int)),0) as total_deaths, ISNULL(SUM(cast(new_deaths as int))/SUM(New_Cases)*100, 0 ) as DeathPercentage
From covid19.dbo.Deaths
Where location not in ('World', 'European Union', 'International','Upper middle income','High income','Lower middle income', 'Low income','Asia', 'Europe', 'North America', 'South America', 'Africa','Oceania','North Korea')
Group by Location, Population
order by PercentPopulationInfected desc

--Aggregated by date
Select Location, Population,date, ISNULL(MAX(new_cases), 0 ) as HighestInfectionCount, ISNULL(Max((new_cases/population))*100, 0 ) as PercentPopulationInfected
From covid19.dbo.Deaths
Where location not in ('World', 'European Union', 'International','Upper middle income','High income','Lower middle income', 'Low income','Asia', 'Europe', 'North America', 'South America', 'Africa','Oceania','North Korea')
Group by Location, Population, date
--order by date
order by PercentPopulationInfected desc
