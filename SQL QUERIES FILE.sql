--select *
--FROM PortfolioProject.dbo.covidDeaths
 -- where continent IS NOT null

SELECT location,total_cases,new_cases,total_deaths,population
FROM PortfolioProject.dbo.covidDeaths
where continent IS NOT null
order by 1,2

--total cases vs total deaths
SELECT location,total_cases,total_deaths,population,date,
(total_deaths / total_cases) *100 as DeathPercentage
FROM PortfolioProject.dbo.covidDeaths
WHERE location = 'Nigeria'
and continent IS NOT null
order by 1,2
offset 10 rows
fetch next 85000 rows only

--total cases vs population

SELECT location,date,total_cases,total_deaths,population,
(total_cases / population) *100 as DeathPercentage
FROM PortfolioProject.dbo.covidDeaths
WHERE location = 'Denmark'
and continent IS NOT null
order by 1,2
offset 10 rows
fetch next 85000 rows only

--countries with highest infecion rate
SELECT 
	location,
	population,
	max(total_cases) AS HighestInfectionCount,
	max((total_cases / population)) * 100 as PercenPopuationInfected
FROM PortfolioProject..covidDeaths
where continent IS NOT null
group by location,population
order by PercenPopuationInfected DESC
offset 10 rows
fetch next 85000 rows only

--showing the countries with the highest DEATHCOUNT PER POPULATION
SELECT 
	location,
	max(cast(total_deaths as int)) as totaldeathcount
FROM PortfolioProject.dbo.covidDeaths
where continent IS NOT null 
group by location
order by totaldeathcount DESC
offset 10 rows
fetch next 85000 rows only

--by continent
SELECT 
	location,
	max(cast(total_deaths as int)) as totaldeathcount
FROM PortfolioProject.dbo.covidDeaths
where continent IS null and location NOT LIKE '%income%'
group by location
order by totaldeathcount DESC

--by day
select date
		,sum(new_cases) as total_cases
		,sum(cast(new_deaths as int)) as total_deaths
		,sum(cast(new_deaths AS int)) / sum(new_cases) * 100 as deathpercentage
from PortfolioProject..CovidDeaths
where continent is not null
GROUP by date
order by 1,2

--looking at total population vs vacination
select cd.continent,cd.location,cd.date,population,cv.new_vaccinations
,sum(convert(int,cv.new_vaccinations)) OVER (partition by cd.location order by cd.location ,cd.date)
from PortfolioProject.dbo.CovidVacination as cv
join PortfolioProject.dbo.CovidDeaths as cd
on cv.location = cd.location and cv.date = cd.date
where cd.continent is not null
order by 1,2,3


-- create a view
create view total_cases_vs_population as
SELECT location,date,total_cases,total_deaths,population,
(total_cases / population) *100 as DeathPercentage
FROM PortfolioProject.dbo.covidDeaths
WHERE location = 'Denmark'
and continent IS NOT null

SELECT *
FROM total_cases_vs_population