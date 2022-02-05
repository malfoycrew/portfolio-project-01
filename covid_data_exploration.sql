--DATA EXPLORATION
SELECT * FROM coviddeaths

-- PERCENTAGE OF TOTAL POPULATION INFECTED BY COVID PER COUNTRY
SELECT continent,location,SUM(total_cases) AS total_cases_till_date,SUM(population) AS total_population_till_date,
((SUM(total_cases)/SUM(population)*100)) AS percent_infected 
FROM coviddeaths
GROUP BY continent,location
ORDER BY percent_infected DESC

--LOOKING AT TOTAL CASES VS TOTAL DEATH PER COUNTRY
SELECT continent,location,SUM(total_cases) AS total_cases_till_date,SUM(total_deaths) AS total_deaths_till_date,
((SUM(total_deaths)/SUM(total_cases))*100) AS percent_dead
FROM coviddeaths
GROUP BY continent,location

--LOOKING AT COUNTRIES WITH MAXIMUM DEATHS
select location,max(total_deaths) as total_death_count
from coviddeaths
where continent is not null
group by location
order by total_death_count desc

-- LOOKING AT DEATHS CONTINENT WISE
select continent, max(total_deaths) AS total_death_count
from coviddeaths
where continent is not null
group by continent
order by total_death_count desc

--GLOBAL NUMBERS
--LOOKING AT NEW CASES GLOBALLY AND NEW DEATHS GLOBALLY ON ANY PARTICULAR DAY
SELECT date, SUM(new_cases) AS new_cases_global,SUM(new_deaths) AS new_deaths_global,
((SUM(new_deaths)/SUM(new_cases))*100) AS PERCENT_DEATH
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date

-- JOINING TABLES coviddeaths and covidvaccinations
--LOOKING AT TOTAL POPULATION VS TOTAL VACCINATIONED AND USING ROLLING COUNT
SELECT coviddeaths.date,coviddeaths.continent,coviddeaths.location,
covidvaccinations.new_vaccinations ,coviddeaths.population,
SUM (covidvaccinations.new_vaccinations) OVER (partition by coviddeaths.location ORDER BY
coviddeaths.location,coviddeaths.date)
FROM coviddeaths
JOIN covidvaccinations
ON coviddeaths.location=covidvaccinations.location
AND coviddeaths.date=covidvaccinations.date
WHERE coviddeaths.continent IS NOT NULL
order by 2,3


-- JOINING TABLES coviddeaths and covidvaccinations
--LOOKING AT TOTAL POPULATION VS TOTAL VACCINATIONED AND USING ROLLING COUNT
WITH popvac(date,continent,location,new_vaccinations,population,rolling_vaccinated)
AS
(
SELECT coviddeaths.date,coviddeaths.continent,coviddeaths.location,
covidvaccinations.new_vaccinations ,coviddeaths.population,
SUM (covidvaccinations.new_vaccinations) OVER (partition by coviddeaths.location ORDER BY
coviddeaths.location,coviddeaths.date) AS rolling_vaccinated
FROM coviddeaths
JOIN covidvaccinations
ON coviddeaths.location=covidvaccinations.location
AND coviddeaths.date=covidvaccinations.date
WHERE coviddeaths.continent IS NOT NULL
--order by 2,3
)
SELECT *,CAST(((rolling_vaccinated/population)*100) AS NUMERIC) FROM popvac



