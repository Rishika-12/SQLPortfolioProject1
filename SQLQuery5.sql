select * 
from PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations$
--order by 3,4

select location,date,total_cases, new_cases, total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1,2

--Total cases vs Total deaths

select location,date,total_cases, total_deaths,100*cast(total_deaths as decimal)/cast(total_cases as decimal) as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%india%'
order by 1,2 

--Total cases Vs Population
select location,date,total_cases, population,100*cast(total_cases as decimal)/cast(population as decimal) as PercentageAffected
from PortfolioProject..CovidDeaths$
--where location like '%india%'
order by 1,2 

--country with high infection rate compared to population
select location,population,MAX(total_cases) as HighestINfectionCount,100*cast(max(total_cases) as decimal)/cast(population as decimal) as PercentageInfected
from PortfolioProject..CovidDeaths$
--where location like '%india%'
group by population,location
order by PercentageInfected desc

--Country with highest death count per population
select location, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%india%'
where continent is not null
group by location
order by TotalDeathCount desc

--by continent
select location, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%india%'
where continent is null
group by location
order by TotalDeathCount desc

--show continent with highest death count per population
select continent, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers
select date,SUM(new_cases),Sum(new_deaths)--, total_deaths,100*cast(total_deaths as decimal)/cast(total_cases as decimal) as DeathPercentage
from PortfolioProject..CovidDeaths$
--where location like '%india%'
where continent is not null
group by date
order by 1,2 


select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations, 100*(cv.new_vaccinations/cd.population) as PercentageVaccinated 
,SUM(cast(cv.new_vaccinations as bigint)) over (partition by cd.location) as ToTalVaccination
from PortfolioProject..CovidDeaths$ as cd
join PortfolioProject..CovidVaccinations$ as cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null 
and cv.new_vaccinations is not null
order by 2,3

select people_fully_vaccinated
from PortfolioProject..CovidVaccinations$

with PopvsVacc(Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as(
select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations,SUM(cast(cv.new_vaccinations as bigint)) over (partition by cd.location) as ToTalVaccination
from PortfolioProject..CovidDeaths$ as cd
join PortfolioProject..CovidVaccinations$ as cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null 
and cv.new_vaccinations is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100 as pecentage
from PopvsVacc

create view PercentpeopleVaccinated as
select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations, 100*(cv.new_vaccinations/cd.population) as PercentageVaccinated 
,SUM(cast(cv.new_vaccinations as bigint)) over (partition by cd.location) as ToTalVaccination
from PortfolioProject..CovidDeaths$ as cd
join PortfolioProject..CovidVaccinations$ as cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null 
and cv.new_vaccinations is not null
--order by 2,3

select * from PercentpeopleVaccinated