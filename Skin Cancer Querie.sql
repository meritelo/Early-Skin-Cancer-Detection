 ---SKIN CANCER QUERIES

 ---PRELIMINARY QUERIES

  SELECT *FROM table1

--How does Gender and Age affects the type of skin lesion?
 SELECT table1.patient_id, table1.age, table1.gender, 
 table2.diagnostic, table2.biopsed
 FROM table1 JOIN table2 ON 
 table1.patient_id=table2.patient_id;

--How does ALCOHOL CONSUMPTION and SMOKING affects the type of skin lesion?

SELECT t1.patient_id, t1.drink, t1.smoke,
t2.diagnostic, t2.biopsed
FROM table1 t1 JOIN table2 t2 ON
t1.patient_id=t2.patient_id;

--How does demographic factors affect the type of skin lesion?

SELECT t1.patient_id, t1.age, t1.gender, t1.drink, t1.smoke,
t1.background_father, t1.background_mother, t1.cancer_history, t1.skin_cancer_history,
t2.diagnostic, t2.biopsed, t2.region
FROM table1 t1 JOIN table2 t2 ON
t1.patient_id=t2.patient_id;


 --How does Environmental factors affect the type of skin lesion? 

SELECT t1.patient_id, t1.has_piped_water, t1.has_sewage_system, t1.pesticide,
t2.diagnostic, t2.biopsed, t2.region
FROM table1 t1 JOIN table2 t2 ON
t1.patient_id=t2.patient_id;


SELECT DISTINCT diagnostic FROM table2;

--Distribution of table based on their diagnostic types 
SELECT t1.patient_id, t2.diagnostic, 
CASE
     WHEN t2.diagnostic = 'NEV' THEN 'Benign'
     WHEN t2.diagnostic = 'BCC' THEN 'Malignant'
     WHEN t2.diagnostic = 'SEK' THEN 'Benign'
     WHEN t2.diagnostic = 'ACK' THEN 'Malignant'
     WHEN t2.diagnostic = 'SCC' THEN 'Malignant'
	 WHEN t2.diagnostic = 'MEL' THEN 'Malignant'
     ELSE 'Unknown'
 END AS Diagnostic_type
 FROM table1 t1 JOIN table2 t2 ON
 t1.patient_id=t2.patient_id;



-- What is the number of people with Malignant type and the number of people with Benign?

SELECT COUNT (t1.patient_id) AS total_count, t2.diagnostic, 
CASE
     WHEN t2.diagnostic = 'NEV' THEN 'Benign'
     WHEN t2.diagnostic = 'BCC' THEN 'Malignant'
     WHEN t2.diagnostic = 'SEK' THEN 'Benign'
     WHEN t2.diagnostic = 'ACK' THEN 'Malignant'
     WHEN t2.diagnostic = 'SCC' THEN 'Malignant'
	 WHEN t2.diagnostic = 'MEL' THEN 'Malignant'
     ELSE 'Unknown'
 END AS Diagnostic_type
 FROM table1 t1 JOIN table2 t2 ON
 t1.patient_id=t2.patient_id
 GROUP BY Diagnostic_type, t2.diagnostic
 ORDER BY total_count DESC;



SELECT 
    CASE
        WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
        WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
        ELSE 'Unknown'
    END AS Diagnostic_type,
    COUNT(*) AS total_count
FROM 
    table1 t1
JOIN 
    table2 t2 ON t1.patient_id = t2.patient_id
GROUP BY 
    CASE
        WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
        WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
        ELSE 'Unknown'
    END;


-- what is the total number and percentage of people who have malignant and benign types respectively?

SELECT 
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        0
    ) AS percentage
FROM (
    SELECT diagnostic,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY Diagnostic_type;

-- what is the number and percentage of people (male and female) who have malignant and benign 

SELECT 
    gender,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY gender),
        2
    ) AS percentage
FROM (
    SELECT 
        t1.gender,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')  -- Only include known types
) AS sub
GROUP BY 
    gender, 
    Diagnostic_type;

-- an extra query for also analyzing lesions (diagnostic type) based on gender

SELECT gender, COUNT (*),
		COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END) as benign_count,
		ROUND(
		100.0 * COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END) / COUNT(*),0) AS benign_percentage,

		COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) AS malignant_count,
		round(
		100.0 * COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) / COUNT(*),0) AS malignant_percentage
		

FROM(
		SELECT gender,
		CASE
			WHEN diagnostic IN ('NEV', 'SEK') THEN 'benign'
			WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
			ELSE 'unknown' END AS diagnostic_type
		FROM table1 t1 
JOIN table2 t2 ON t1.patient_id = t2.patient_id

WHERE diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub

GROUP BY gender;


--How does smoking influence diagnostic type?

SELECT smoke, COUNT (patient_id)
FROM table1
GROUP BY smoke;

SELECT 
    smoke,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY smoke),
        0
    ) AS percentage
FROM (
    SELECT 
        t1.smoke,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL') 
) AS sub
GROUP BY 
    smoke, 
    Diagnostic_type;



-- How does alcohol consumption influence diagnostic type?

SELECT 
    drink,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY drink),
        0
    ) AS percentage
FROM (
    SELECT 
        t1.drink,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL') 
) AS sub
GROUP BY 
    drink, 
    Diagnostic_type;


--How does exposure to pesticide influence diagnostic type
	SELECT 
    pesticide,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY pesticide),
        0
    ) AS percentage
FROM (
    SELECT 
        t1.pesticide,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL') 
) AS sub
GROUP BY 
    pesticide, 
    Diagnostic_type;

	
--How does having sewage system influence diagnostic type?
	SELECT 
    has_sewage_system,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY has_sewage_system),
        2
    ) AS percentage
FROM (
    SELECT 
        t1.has_sewage_system,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')  
) AS sub
GROUP BY 
    has_sewage_system, 
    Diagnostic_type;


--How does access to pipe water influence diagnostic type?
		SELECT 
    has_piped_water,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY has_piped_water),
        2
    ) AS percentage
FROM (
    SELECT 
        t1.has_piped_water,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL') 
) AS sub
GROUP BY 
    has_piped_water, 
    Diagnostic_type;



--How does previous skin cancer history influence diagnostic type?

SELECT 
    skin_cancer_history,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY skin_cancer_history),
        2
    ) AS percentage
FROM (
    SELECT 
        t1.skin_cancer_history,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL') 
) AS sub
GROUP BY 
    skin_cancer_history, 
    Diagnostic_type;


--How does cancer history influences diagnostic type?
 
SELECT 
    cancer_history,
    Diagnostic_type,
    COUNT(*) AS total_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY cancer_history),
        2
    ) AS percentage
FROM (
    SELECT 
        t1.cancer_history,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY 
    cancer_history, 
    Diagnostic_type;

	
-- How father's cancer background influences diagnostic type
SELECT 
    background_father,
    Diagnostic_type,
    COUNT(*) AS total_count
    
FROM (
    SELECT 
        t1.background_father,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') 
) AS sub
GROUP BY 
    background_father, 
    Diagnostic_type
	order by Total_count desc;



--How mother's cancer background influences diagnostic type 
SELECT 
    background_mother,
    Diagnostic_type,
    COUNT(*) AS total_count
FROM (
    SELECT 
        t1.background_mother,
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY 
    background_mother, 
    Diagnostic_type
	order by total_count desc;


--Does the prevalence of malignant lesions increase with age group?
--Group patients into age brackets (e.g., 0–20, 21–40, 41–60, 61+)

SELECT age_group,
		COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 ELSE 0 END) AS malignant_count,
		ROUND(100.0 * COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 ELSE 0 END)/
		SUM(COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 ELSE 0 END)) OVER (),1) AS 
		malignant_percentage	
FROM(
		SELECT		
			CASE WHEN age <= 20 THEN '0-20'
			 WHEN age BETWEEN 21 AND 40 THEN '21-40'
			 WHEN age BETWEEN 41 AND 60 THEN '41-60'
			 WHEN age > 60 THEN '61-100' END AS age_group,
	 
		case WHEN diagnostic IN ('NEV','SEK') THEN 'benign'
			 WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
			 ELSE 'unknown' END AS diagnostic_type
			 
FROM table1 t1 JOIN table2 t2 on t1.patient_id = t2.patient_id
WHERE diagnostic in ('BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY age_group
ORDER BY malignant_count DESC;


-- Distribution by leision characteristics of each cancer type? 

SELECT 
    Diagnostic_type,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN itch = true THEN 1 ELSE 0 END) AS "Itch",
    SUM(CASE WHEN grew = true THEN 1 ELSE 0 END) AS "Growth",
    SUM(CASE WHEN hurt = true THEN 1 ELSE 0 END) AS "Pain",
    SUM(CASE WHEN changed = true THEN 1 ELSE 0 END) AS "Changed",
    SUM(CASE WHEN bleed = true THEN 1 ELSE 0 END) AS "Bleed",
    SUM(CASE WHEN elevation = true THEN 1 ELSE 0 END) AS "Elevated",
    ROUND(AVG((diameter_1 + diameter_2)/2.0)::numeric, 2) AS avg_diameter
FROM (
    SELECT 
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type,
        t2.*
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY Diagnostic_type
ORDER BY total_lesions DESC;


-- Distribution based on biopsed to determine the diagnostic type
SELECT 
    Diagnostic_type,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN biopsed = true THEN 1 ELSE 0 END) AS biopsed_count,
    SUM(CASE WHEN biopsed = false THEN 1 ELSE 0 END) AS not_biopsed_count,
    ROUND(
        100.0 * SUM(CASE WHEN biopsed = true THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS biopsed_percentage,
    ROUND(AVG((diameter_1 + diameter_2)/2.0)::numeric, 2) AS avg_lesion_diameter
FROM (
    SELECT 
        CASE
            WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 'Benign'
            WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'Malignant'
            ELSE 'Unknown'
        END AS Diagnostic_type,
        t2.*
    FROM 
        table1 t1
    JOIN 
        table2 t2 ON t1.patient_id = t2.patient_id
    WHERE 
        t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY Diagnostic_type
ORDER BY total_lesions DESC;


-- Distribution of diagnostic types based on region
	SELECT 
    t2.region,
    COUNT(*) AS total_cases,
    COUNT(CASE 
        WHEN t2.diagnostic IN ('NEV', 'SEK') THEN 1 
        END) AS benign_count,
    COUNT(CASE 
        WHEN t2.diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 1 
        END) AS malignant_count
FROM 
    table1 t1
JOIN 
    table2 t2 ON t1.patient_id = t2.patient_id
WHERE 
    t2.diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
GROUP BY 
    t2.region
ORDER BY 
    malignant_count DESC;
	

--Which lesion region has the highest rate of malignant lesions?
--Group by region and compare malignant vs benign lesion counts and percentages.

SELECT COALESCE(region, 'TOTAL') AS region, -- I USED COALESCE TO CHANGE THE NULL VALUE IN THE REGION COLUMN TO TOTAL.
		COUNT(*) AS total_lesions,
		COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) AS malignant_count,
		round(
			100.00 * COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END)/COUNT(*), 2
		) AS malignant_percentage,
		COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END) AS benign_count,
		ROUND(
			100.00*COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END)/COUNT(*), 2
		)AS benign_percentage
FROM(
	SELECT region,
			CASE
				WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
            	WHEN diagnostic IN ('NEV', 'SEK') THEN 'benign'
            	ELSE 'Unknown'
        		END AS diagnostic_type
	FROM table1 t1
	JOIN table2 t2 ON t1.patient_id = t2.patient_id
	WHERE diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY ROLLUP(region)
ORDER BY CASE WHEN region IS NULL THEN 1 ELSE 0 END, malignant_count DESC;


-- Is there any correlation between the lesion being itchy, hurtful or bleeding and it being malignant?
--Show the percentage of malignant lesions when itch and/or hurt is true.

SELECT itch, hurt, bleed,
		COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) AS malignant_count,
		COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END) AS benign_count,
		ROUND(
			100.00 * COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END)/COUNT(*), 2
		) AS malignant_percentage,
		round(
			100.00*COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END)/COUNT(*), 2
		)AS benign_percentage

FROM(
	SELECT itch, hurt, bleed,
			CASE
				WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
            	WHEN diagnostic IN ('NEV', 'SEK') THEN 'benign'
            	ELSE 'Unknown'
        		END AS diagnostic_type
	FROM table1 t1
	JOIN table2 t2 ON t1.patient_id = t2.patient_id
	WHERE diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY itch, hurt, bleed
ORDER BY malignant_percentage DESC;


-- Calculate malignancy rate based on the symptom_scores

SELECT 
    (CASE WHEN itch = 'true' THEN 1 ELSE 0 END +
     CASE WHEN hurt = 'true' THEN 1 ELSE 0 END +
     CASE WHEN bleed = 'true' THEN 1 ELSE 0 END +
     CASE WHEN grew = 'true' THEN 1 ELSE 0 END +
     CASE WHEN elevation = 'true' THEN 1 ELSE 0 END +
     CASE WHEN changed = 'true' THEN 1 ELSE 0 END
    ) AS symptom_score,
    
    COUNT(*) AS total_cases,
    COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) AS malignant_count,
	COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END) AS benign_count,
    ROUND(
        100.0 * COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) / COUNT(*), 2
    ) AS malignant_percentage
FROM (
    SELECT 
        itch, hurt, bleed, grew, elevation, changed,
        CASE
            WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
            WHEN diagnostic IN ('NEV', 'SEK') THEN 'benign'
            ELSE 'unknown'
        END AS diagnostic_type
    FROM table1 t1
    JOIN table2 t2 ON t1.patient_id = t2.patient_id
    WHERE diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY symptom_score
ORDER BY symptom_score DESC;


--Which gender is more likely to have large malignant lesions?
--Define “large” as lesions where diameter or second_diameter > 6mm.

SELECT gender,
		diagnostic_type,
		COUNT(*)as total_lesions,
		COUNT(CASE WHEN lesion_size > 6 THEN 1 END) AS large_lesions,
		round(100.0*COUNT(CASE WHEN lesion_size > 6 THEN 1 END)/COUNT(*),2)AS large_lesion_percentage
FROM(
	 SELECT gender,
	 		CASE WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
            WHEN diagnostic IN ('NEV', 'SEK') THEN 'benign'
            ELSE 'unknown'
        END AS diagnostic_type,

			(diameter_1 + diameter_2)/2.0 ::numeric as lesion_size
    FROM table1 t1
    JOIN table2 t2 ON t1.patient_id = t2.patient_id
    WHERE diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY gender, diagnostic_type
ORDER BY gender, diagnostic_type;


-- How does the fitspatrick scale affects the data set?
-- firstly I will run a query to explain the different fitspatrick skin types.

SELECT fitspatrick,
		CASE WHEN fitspatrick = 1 THEN 'I'
			 WHEN fitspatrick = 2 THEN 'II'
			 WHEN fitspatrick = 3 THEN 'III'
			 WHEN fitspatrick = 4 THEN 'IV'
			 WHEN fitspatrick = 5 THEN 'V'
			 WHEN fitspatrick = 6 THEN 'VI'
			 ELSE 'NULL' END AS skin_type,
			 
		CASE WHEN fitspatrick = 1 THEN 'very fair/ pale white skin'
			 WHEN fitspatrick = 2 THEN 'fair skin'
			 WHEN fitspatrick = 3 THEN 'medium white to olive skin'
			 WHEN fitspatrick = 4 THEN 'olive or light brown skin'
			 WHEN fitspatrick = 5 THEN 'Brown skin'
			 WHEN fitspatrick = 6 THEN 'dark brown or black skin'
			 ELSE 'NULL' END AS skin_description,

		CASE WHEN fitspatrick = 1 THEN 'Always burn, never tans'
			 WHEN fitspatrick = 2 THEN 'usually burns, tans poorly'
			 WHEN fitspatrick = 3 THEN 'sometimes burns, gradually tans'
			 WHEN fitspatrick = 4 THEN 'rarely burns, tans well'
			 WHEN fitspatrick = 5 THEN 'very rarely burns, tans very easily'
			 WHEN fitspatrick = 6 THEN 'never burns, deeply pigmented'
			 ELSE 'NULL' END AS reaction_to_sun
		FROM table2
		GROUP BY fitspatrick
		ORDER BY fitspatrick;
			 
-- How the fitzpatrick scale affects the rate of malignant lesions.
SELECT fitspatrick,
	    COUNT(*),
		COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) AS malignant_count,
		COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END) AS benign_count,
		ROUND(100.0 * COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END)/
			COUNT(*),1) AS malignant_percentage
FROM(
	SELECT fitspatrick,
			CASE WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
            WHEN diagnostic IN ('NEV', 'SEK') THEN 'benign'
            ELSE 'unknown'
        END AS diagnostic_type
    FROM table1 t1
    JOIN table2 t2 ON t1.patient_id = t2.patient_id
    WHERE diagnostic IN ('NEV', 'SEK', 'BCC', 'ACK', 'SCC', 'MEL')
) AS sub
GROUP BY fitspatrick
ORDER BY fitspatrick;

-- Identifying the top 10 patient profiles (combinations of risk factors) most likely
-- to have malignant lesions?
-- Using:
-- Smoking/drinking
-- Skin cancer history
-- Cancer history
-- Lesion behaviors


SELECT 
    smoke,
    drink,
    skin_cancer_history,
	cancer_history,
    grew,
    changed,
    itch,
    hurt,
    bleed,
	elevation,
    
    COUNT(*) AS total_patients,
    COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) AS malignant_count,
    COUNT(CASE WHEN diagnostic_type = 'benign' THEN 1 END) AS benign_count,
    
    ROUND(
        100.0 * COUNT(CASE WHEN diagnostic_type = 'malignant' THEN 1 END) / COUNT(*),
        2
    ) AS malignancy_percentage

FROM (
    SELECT 
            smoke,
    		drink,
   		    skin_cancer_history,
			cancer_history,
  		    grew,
   		    changed,
    		itch,
   		    hurt,
   		    bleed,
			elevation,  
        CASE 
            WHEN diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL') THEN 'malignant'
            WHEN diagnostic IN ('NEV', 'SEK') THEN 'benign'
            ELSE 'unknown'
        END AS diagnostic_type
        
    FROM table1 t1
    JOIN table2 t2 ON t1.patient_id = t2.patient_id
    WHERE diagnostic IN ('BCC', 'ACK', 'SCC', 'MEL', 'NEV', 'SEK')
) AS sub
GROUP BY 
    smoke, drink, skin_cancer_history, cancer_history, grew, changed, itch,
	hurt, bleed, elevation
HAVING COUNT(*) >= 5 -- filters out low-volume profiles

ORDER BY malignancy_percentage DESC
LIMIT 10;

