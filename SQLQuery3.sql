Select * 
From PortfolioProject..CovidDeaths
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccination
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
order by 1,2


--Total Cases Vs Population

Select location, date, total_cases, population, (total_deaths/population)*100 as PopularionPercentage 
From PortfolioProject..CovidDeaths
order by 1,2

--Country with highest Infection Rate

Select location, MAX(total_cases) as HighestInfectionRate, population, MAX((total_deaths/population))*100 as PercentInfected
From PortfolioProject..CovidDeaths
Group by location,population
order by PercentInfected DESC

--Highest Death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by TotalDeaths DESC

Select continent, MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeaths DESC



--showing continent with highest death count

Select continent, MAX(cast(total_deaths as int)) as HighestDeaths
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by HighestDeaths DESC

Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2

Select *
From PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeaths dea
    on dea.location = vac.location
	and dea.date = vac.date


	
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations as BIGINT)) OVER(Partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
From PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeaths dea
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null

	--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_Vacctinations numeric,
  RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations as BIGINT)) OVER(Partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
From PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeaths dea
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null

Select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating view

Drop view if exists PercentPopulationVaccinated 

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations as BIGINT)) OVER(Partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
From PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeaths dea
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null

Select *
From PercentPopulationVaccinated 

	
