/*
Proyecto exploratorio de data COVID-19: Perú / Continentes / Global

Herramientas utilizadas: Joins, CTE's, Temp Tables, Windows Functions, Funciones Aggregate, Creación de Views, Convesión de Tipos de Data
*/

-- Data utilizada

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent is not null 
ORDER by 1,2


---- PERÚ ----

-- total de casos vs total muertes
-- Muestra probabilidad de morir si se contrae COVID-19

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PorcentajeMuertes
FROM CovidDeaths
WHERE location = 'Peru'
AND continent IS NOT NULL
ORDER BY 1,2


-- total de casos vs población
-- muestra que porcentaje de la población está infectada con COVID
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PorcentajePoblacionInfectada
FROM CovidDeaths
WHERE location = 'Peru'
AND continent IS NOT NULL
ORDER BY 1,2

---- POR PAÍS ----

-- paises con mayor tasa de infección con respecto a su población
SELECT location, population, MAX(total_cases) AS MaximoTotalCasos, MAX((total_cases/population))*100 AS PorcentajePoblacionInfectada
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PorcentajePoblacionInfectada DESC


-- paises con mayor total de muertes
SELECT location, MAX(cast(total_deaths AS int)) AS TotalMuertes
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalMuertes DESC

---- POR CONTINENTE ----

-- contienentes con mayor total de muertes
SELECT continent, MAX(cast(total_deaths AS int)) AS TotalMuertes
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalMuertes DESC


---- GLOBAL ----

-- porcentaje de muertes del total de casos
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS TotalMuertes, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS PorcentajeMuertes
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- población total vs personas vacunadas
-- muestra el porcentaje de la población que ha recibido al menos una vacuna contra el COVID

-- query inicial
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS AgregadoPersonasVacunadas
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- utilizando tabla CTE y query inicial
WITH PobVsVac (Continent, Location, Date, Population, New_Vaccinations, AgregadoPersonasVacunadas)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS AgregadoPersonasVacunadas
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
)

SELECT *, (AgregadoPersonasVacunadas/population)*100 AS AgregadoPorcentajePersonasVacunadas 
FROM PobVsVac


-- utilizando tabla TEMP y query inicial
DROP TABLE IF EXISTS #PorcentajePersonasVacunadas 
CREATE TABLE #PorcentajePersonasVacunadas 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
AgregadoPersonasVacunadas numeric
)

Insert into #PorcentajePersonasVacunadas 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS AgregadoPersonasVacunadas
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

SELECT *, (AgregadoPersonasVacunadas/population)*100 AS AgregadoPorcentajePersonasVacunadas 
FROM #PorcentajePersonasVacunadas

-- Creando VIEW para almacenar la data para visualizaciones posteriores

CREATE VIEW PorcentajePersonasVacunadas AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS AgregadoPersonasVacunadas
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 



