-- Track changes in name popularity

-- Find the overall most popular girl and boy names and show how they have changed in popularity rankings over the years


SELECT * FROM 
(WITH new_table AS 
	(SELECT Name, Gender, SUM(Births) as Total
	FROM names
	GROUP BY Name, Gender
    )
    
SELECT Name, Gender, Total,
	   ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY Total DESC) AS Popularity
FROM new_table) AS rankings
WHERE Name = 'Jessica' or Name = 'Michael';



-- i need to create a table thats grouped by year and has the ranking for that year for each name
-- then i can just select michael and jessica and see what their rankings across each year is

WITH ranking_table AS 
	(WITH new_table AS 
		(SELECT Year, Name, SUM(Births) as Total
		FROM names
		GROUP BY Year, Name)
	SELECT Year, Name, Total, 
			ROW_NUMBER() OVER(PARTITION BY Year ORDER BY TOTAL DESC) AS Popularity
	FROM new_table)

SELECT * 
FROM ranking_table 
WHERE Name = 'Jessica' or Name = 'Michael';

-- For each year, return the 3 most popular girl names and 3 most popular boy names

WITH ranking_table AS 
	(WITH new_table AS 
		(SELECT Gender, Year, Name, SUM(Births) as Total
		FROM names
		GROUP BY Gender, Year, Name)
	SELECT Year, Name,Gender, Total, 
			ROW_NUMBER() OVER(PARTITION BY Year, Gender ORDER BY TOTAL DESC) AS Popularity
	FROM new_table)

SELECT * 
FROM ranking_table 
WHERE Popularity < 4;

-- For each decade, return the 3 most popular girl names and 3 most popular boy names

WITH ranking_table AS 
	(WITH new_table AS 
		(SELECT 
        CASE
			WHEN Year BETWEEN 1980 AND 1989 THEN '80s'
            WHEN Year BETWEEN 1990 AND 1999 THEN '90s'
            WHEN Year BETWEEN 2000 AND 2009 THEN '00s'
            ELSE 'None'
		END AS Decade,
        Gender, Name, SUM(Births) as Total
		FROM names
		GROUP BY Gender, Decade, Name)
	SELECT Decade, Name,Gender, Total, 
			ROW_NUMBER() OVER(PARTITION BY Decade, Gender ORDER BY TOTAL DESC) AS Popularity
	FROM new_table)

SELECT * 
FROM ranking_table 
WHERE Popularity < 4;
