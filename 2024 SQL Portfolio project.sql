
-- Selecting the top 1000 rows after importing table

SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
  FROM [Portfolio Project 2024].[dbo].[Covid Deaths 2024]

-- Showing count of number of rows in the newly imported table 

select count (*) from [Covid Deaths 2024]

select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project 2024]..[Covid Deaths 2024]
where location is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as Death_percentage
from [Portfolio Project 2024]..[Covid Deaths 2024]
where location is not null
order by 1,2

-- Likelihood of dying by Covid-19 in Nigeria if affected
select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as Death_percentage
from [Covid Deaths 2024]
where location = 'Nigeria'
order by 1,2


-- Looking at Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as Death_percentage
from [Covid Deaths 2024]
order by 1,2

-- Percentage of the Nigerians that got covid-19

select location, date, total_cases, population, (total_cases/population)*100 as Covid_Spread_Percentage
from [Covid Deaths 2024]
where location =('Nigeria')
order by 1,2

-- Countries Covid-19 Peak Numbers as compared to Population

select location, population, max(total_cases) as PeakInfectionNumber, max((total_cases/population)*100) as Covid_Spread_Percentage
from [Covid Deaths 2024]
group by location, population
order by Covid_Spread_Percentage desc

-- Countries with the highest number of cases

Select location, MAX(total_cases) as Number_of_cases
from [Portfolio Project 2024]..[Covid Deaths 2024]
where continent is not null
group by location
order by Number_of_cases desc


-- Countries with the highest Death count

Select location, MAX(total_deaths) as Death_Count
from [Portfolio Project 2024]..[Covid Deaths 2024]
where continent is not null
group by location
order by Death_Count desc

-- Continents with the highest amount of cases

Select location,  MAX(total_cases) as Number_of_cases
from [Portfolio Project 2024]..[Covid Deaths 2024]
where not location = 'Low income' and not location = 'Lower middle income' 
and not location = 'Upper middle income' and not location = 'High income'
and not location = 'World' and continent is null
group by location, continent
order by Number_of_cases desc

-- Social Class demographics most affected by Covid-19

Select location,  MAX(total_cases) as Number_of_cases
from [Portfolio Project 2024]..[Covid Deaths 2024]
where not location = 'Asia' and not location = 'Europe' and not location = 'European Union'
and not location = 'Africa' and not location = 'North America' and not location = 'Oceania'
and not location = 'South America' and not location = 'World' and continent is null
group by location, continent
order by Number_of_cases desc

-- Continents with the highest death count per population

select location as Continents, sum(new_deaths) as Death_Count, max((total_deaths/Population)*100) as Percentage_of_deaths_per_population
from [Portfolio Project 2024]..[Covid Deaths 2024]
where continent is null
group by location
order by 3


-- Social Class demographics with highest death count per population

Select location as Socal_Class,  sum(new_deaths) as Death_Count, MAX((total_deaths/population)*100) as Percentage_of_deaths_per_population
from [Portfolio Project 2024]..[Covid Deaths 2024]
where not location = 'Asia' and not location = 'Europe' and not location = 'European Union'
and not location = 'Africa' and not location = 'North America' and not location = 'Oceania'
and not location = 'South America' and not location = 'World' and continent is null
group by location
order by Percentage_of_deaths_per_population desc
 

 -- Joining Covid Deaths and Covid Vaccinations tables

 select *
 from [Portfolio Project 2024]..[Covid Deaths 2024] dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.iso_code = vac.iso_code
 and dea.location = vac.location

 -- Every County's population vaccination per day

 select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
 from [Portfolio Project 2024]..[Covid Deaths 2024]dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.location = vac.location
 where dea.continent is not null
 order by 1

 -- Every Country's population vaccination progress per day showing each country's total 

 select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,
 dea.date) as Vaccination_Progression
  from [Portfolio Project 2024]..[Covid Deaths 2024]dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,3

 -- Each Continents Vaccination progress per day

 select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,
 dea.date) as Vaccination_Progression
  from [Portfolio Project 2024]..[Covid Deaths 2024]dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is null and not dea.location = 'High income' 
 and not dea.location = 'Low income'
 and not dea.location = 'Lower middle income'
 and not dea.location = 'Upper middle income'
 order by 1,3

 -- Each Social Demographics vaccination progress per day

select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,
 dea.date) as Vaccination_Progression
  from [Portfolio Project 2024]..[Covid Deaths 2024]dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is null and not dea.location = 'Africa' 
 and not dea.location = 'Asia'
 and not dea.location = 'Europe'
 and not dea.location = 'North America'
 and not dea.location = 'South America'
 and not dea.location = 'Oceania'
 and not dea.location = 'World'
 and not dea.location = 'European Union'
 order by 1,3

 --(Using CTE) Percentage of Each County's population that has been Vaccinated by day

 With PopVac (location, continent, date, population, Vaccination_Progression, New_Vaccinations)
 as
 (select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,
 dea.date) as Vaccination_Progression
  from [Portfolio Project 2024]..[Covid Deaths 2024]dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null)

 select *, (Vaccination_Progression/population)*100 as Population_Percentage_Vaccinated
 from PopVac 

  --(Using Temp Table) Percentage of Each County's population that has been Vaccinated by day

  Drop table if EXISTS #Popualtion_Percentage_Vaccinated_Temp -- This Line is important if alterations are to be made to the temp table in the future
  Create Table #Popualtion_Percentage_Vaccinated_Temp
  (location nvarchar (255),
  continent nvarchar (255),
  date datetime,
  population int,
  new_vaccinations Bigint,
  Vaccination_Progression bigint)

  insert into #Popualtion_Percentage_Vaccinated_Temp
  select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,
 dea.date) as Vaccination_Progression
  from [Portfolio Project 2024]..[Covid Deaths 2024]dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null

 select *
 from #Popualtion_Percentage_Vaccinated_Temp

 

 -- Creating view for Data Visualization

 Create view Vaccination_Numbers as
 select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,
 dea.date) as Vaccination_Progression
  from [Portfolio Project 2024]..[Covid Deaths 2024]dea
 join [Portfolio Project 2024]..[Covid Vaccination 2024] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null