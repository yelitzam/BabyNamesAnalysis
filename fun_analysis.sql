-- Objective 4

-- Find the 10 most popular androgynous names
SELECT Name, COUNT(Distinct Gender) AS num_genders, SUM(Births) AS Total FROM Names
GROUP BY Name
HAVING num_genders > 1
ORDER BY Total DESC
LIMIT 10;

-- Find the length of the shortest and longest names and identify the most popular short names
SELECT Name, Births, LENGTH(Name) AS Length
FROM Names
ORDER BY Length DESC;
-- max lngth is 15, min length is 2

WITH new_names AS 
(
	SELECT * 
	FROM names
	WHERE LENGTH(Name) IN (2,15)
)
SELECT Name, Sum(Births) AS Total
FROM new_names
GROUP BY Name
ORDER BY Total DESC;

