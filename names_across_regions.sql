-- Objective 3
-- Analyzing names across regions

-- Return the number of babies born in each of the six regions. 


WITH new_table AS (
	WITH clean_regions AS (
		SELECT  State,
			CASE 
			WHEN Region = 'New England' THEN 'New_England'
			ELSE Region
			END AS clean_region
		FROM regions
		UNION
        SELECT 'MI' AS State, 'Midwest' AS Region
	)
	SELECT n.State, Name, Births, r.clean_region FROM names n
	JOIN clean_regions r
	ON n.State = r.State
)

SELECT clean_region, SUM(Births) AS Total
FROM new_table
GROUP By clean_region;



-- Return the 3 most popular girl names and 3 most popular boy names within each region
SELECT * FROM (
	WITH new_table AS (
		WITH clean_regions AS (
			SELECT  State,
				CASE 
				WHEN Region = 'New England' THEN 'New_England'
				ELSE Region
				END AS clean_region
			FROM regions
			UNION
			SELECT 'MI' AS State, 'Midwest' AS Region)

		SELECT r.clean_region, Gender, Name, SUM(Births) AS Total FROM names n
		JOIN clean_regions r
		ON n.State = r.State
		GROUP By clean_region, Name, Gender
	)

	SELECT clean_region, Name, Gender,
		   ROW_NUMBER() OVER(PARTITION BY clean_region, Gender ORDER BY Total DESC) AS Popularity
	FROM new_table
) AS region_rankings
WHERE Popularity < 4;

