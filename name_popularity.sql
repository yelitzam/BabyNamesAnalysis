-- Objective 1
-- To track changes in name popularity
-- Identify the names that have jumped the most in terms of popularity
USE baby_names_db;
SELECT * FROM names;

-- 1) Find the popular girl and boy name and show how they have changed in popularity rankings over the years
SELECT Name, SUM(Births) as total FROM names
WHERE Gender = 'F'
GROUP BY Name
ORDER BY total DESC
LIMIT 1;
-- The most popular girl name is Jessica with 979095 births between 1980 and 2009. The year with the most Jessica's was 1987 with 76774 births.
-- The least popular year was 2009 with 1781 births.
SELECT Year, SUM(Births) as total FROM names
WHERE Name = 'Jessica'
GROUP BY Name, Year
ORDER BY total DESC;

SELECT * FROM 
(WITH girl_names AS (SELECT Year, Name, SUM(Births) as total FROM names
WHERE Gender = 'F'
GROUP BY Year, Name)

SELECT Year, Name, 
	row_number() OVER (PARTITION BY Year ORDER BY total DESC) AS popularity
FROM girl_names) AS popular_girl_names 
WHERE Name = "Jessica";

SELECT Name, SUM(Births) as total FROM names
WHERE Gender = 'M'
GROUP BY Name
ORDER BY total DESC
LIMIT 1;

SELECT Year, SUM(Births) as total FROM names
WHERE Name = 'Michael'
GROUP BY Name, Year
ORDER BY total DESC;

SELECT * FROM 
(WITH boy_names AS (SELECT Year, Name, SUM(Births) as total FROM names
WHERE Gender = 'M'
GROUP BY Year, Name)

SELECT Year, Name, 
	row_number() OVER (PARTITION BY Year ORDER BY total DESC) AS popularity
FROM boy_names) AS popular_boy_names 
WHERE Name = "Michael";
-- The most popular boy name is Michael with 1453469 births between 1980 and 2009. The year with the most Michael's was 1981 with 92102 births.
-- The least popular year was 2009 with 7593 births.


-- 2) Find the names with the biggest jumps in popularity from the first year of the data set to the last year
WITH names_1980 AS
	(WITH all_names AS (SELECT Year, Name, SUM(Births) as total FROM names
	GROUP BY Year, Name)

	SELECT Year, Name, 
		row_number() OVER (PARTITION BY Year ORDER BY total DESC) AS popularity
	FROM all_names
	WHERE Year = 1980), 

names_2009 AS (

	WITH all_names AS (SELECT Year, Name, SUM(Births) as total FROM names
	GROUP BY Year, Name)

	SELECT Year, Name, 
		row_number() OVER (PARTITION BY Year ORDER BY total DESC) AS popularity
	FROM all_names
	WHERE Year = 2009
    )
    
    
SELECT t1.Year, t1.Name, t1.popularity, t2.Year, t2.Name, t2.popularity, 
CAST(t2.popularity AS SIGNED)- CAST(t1.popularity AS SIGNED) AS diff
FROM names_1980 t1
INNER JOIN names_2009 t2
ON t1.Name = t2.Name;






