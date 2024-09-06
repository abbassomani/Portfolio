SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT *
FROM covidvaccinations
ORDER BY 3,4;

-- SELECTING DATA I WILL NEED

SELECT
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS (SHOWS LIKELYHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY)

SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 AS deathpercentage
FROM coviddeaths
WHERE location LIKE '%states%'
AND continent IS NOT NULL
ORDER BY 1,2;

-- LOOKING AT TOTAL CASES VS POPULATION (PERCENTAGE OF POPULATION THAT GOT COVID)

SELECT
	location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 AS population_affected_percentage
FROM coviddeaths
WHERE location LIKE '%states%'
ORDER BY 1,2;

--COUNTRIED WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT
	location,
	population,
	MAX(total_cases) AS highest_infection_count,
	MAX(total_cases/population)*100 AS population_affected_percentage
FROM coviddeaths
--WHERE location LIKE '%states%'
GROUP BY location, population
ORDER BY population_affected_percentage DESC;

-- COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION WHERE CONTINENT IS NOT NULL

SELECT
	location,
	MAX(CAST(total_deaths as int)) AS total_death_count
FROM coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION WHERE CONTINENT IS NULL

SELECT
	location,
	MAX(CAST(total_deaths as int)) AS total_death_count
FROM coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

SELECT
	continent,
	MAX(CAST(total_deaths as int)) AS total_death_count
FROM coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- GLOBAL NUMBERS

SELECT
	date,
	SUM(new_cases) AS total_cases,
	SUM(CAST(new_deaths as int)) AS total_deaths,
	SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS deathpercentage
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- GLOBAL CASES VS DEATH PERCENTAGE

SELECT
	SUM(new_cases) AS total_cases,
	SUM(CAST(new_deaths as int)) AS total_deaths,
	SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS deathpercentage
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
ORDER BY 1,2;

--OVERVIEW OF THE VACCINATION TABLE

SELECT *
FROM covidvaccinations;

--JOINING THE COVID DEATH TABLE WITH THE COVID VACCINATION TABLE

SELECT *
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date;

-- SELECTING DATA REQUIRED

SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
-- (rollingpeoplevaccinated/population)*100
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- USING CTE

WITH popvsvac(
			Continent,
			Location,
			Date,
			Population,
			New_Vaccinations,
			RollingPeopleVaccinated)
as
(
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
-- (rollingpeoplevaccinated/population)*100
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3)
)
SELECT *, (rollingpeoplevaccinated/population)*100
FROM popvsvac;

--TEMP TABLE

CREATE TABLE #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #percentpopulationvaccinated
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
-- (rollingpeoplevaccinated/population)*100
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3)

SELECT *, (rollingpeoplevaccinated/population)*100
FROM #percentpopulationvaccinated;

--TEMP TABLE BUT WITH NULL VALUES. THE PREVIOUS ONE HAS A WHERE CONDITION SO WE NEED TO USE THE DROP FUNCTION

DROP TABLE IF EXISTS #percentpopulationvaccinated
CREATE TABLE #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #percentpopulationvaccinated
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
-- (rollingpeoplevaccinated/population)*100
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3)

SELECT *, (rollingpeoplevaccinated/population)*100
FROM #percentpopulationvaccinated;

-- CREATING A VIEW TO STORE DATE FOR VISUALIZATIONS LATER

CREATE VIEW percentpopulationvaccinated AS
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS rollingpeoplevaccinated
-- (rollingpeoplevaccinated/population)*100
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3);

SELECT *
FROM percentpopulationvaccinated;