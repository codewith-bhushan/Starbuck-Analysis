

DROP TABLE IF EXISTS starbucks_directory;
DROP TABLE IF EXISTS starbucks_nutrition;


CREATE TABLE starbucks_nutrition (
    beverage_id SERIAL PRIMARY KEY,
    beverage_category VARCHAR(150),
    beverage VARCHAR(255),
    beverage_prep VARCHAR(255),
    calories INTEGER,
    total_fat_g VARCHAR(50),
    trans_fat_g NUMERIC(10,2),
    saturated_fat_g NUMERIC(10,2),
    sodium_mg INTEGER,
    total_carbohydrates_g INTEGER,
    cholesterol_mg INTEGER,
    dietary_fibre_g INTEGER,
    sugars_g INTEGER,
    protein_g NUMERIC(10,2),
    vitamin_a_dv VARCHAR(20),
    vitamin_c_dv VARCHAR(20),
    calcium_dv VARCHAR(20),
    iron_dv VARCHAR(20),
    caffeine_mg VARCHAR(50)
);


-- ============================================================
-- STEP 5: CREATE STARBUCKS DIRECTORY TABLE
-- CSV: directory.csv
-- IMPORTANT: store_id is generated automatically.
-- Do NOT include store_id while importing the CSV.
-- ============================================================

CREATE TABLE starbucks_directory (
    store_id SERIAL PRIMARY KEY,
    brand VARCHAR(100),
    store_number VARCHAR(100),
    store_name VARCHAR(255),
    ownership_type VARCHAR(100),
    street_address VARCHAR(500),
    city VARCHAR(150),
    state_province VARCHAR(150),
    country VARCHAR(20),
    postcode VARCHAR(50),
    phone_number VARCHAR(100),
    timezone VARCHAR(150),
    longitude NUMERIC(10,4),
    latitude NUMERIC(10,4)
);



SELECT * FROM starbucks_nutrition;
SELECT * FROM starbucks_directory;


-- Q1. Display all beverage records
SELECT *
FROM starbucks_nutrition;


-- Q2. Count total beverages
SELECT COUNT(*) AS total_beverages
FROM starbucks_nutrition;


-- Q3. Display unique beverage categories
SELECT DISTINCT beverage_category
FROM starbucks_nutrition
ORDER BY beverage_category;


-- Q4. Count beverages by category
SELECT beverage_category,
       COUNT(*) AS total_beverages
FROM starbucks_nutrition
GROUP BY beverage_category
ORDER BY total_beverages DESC;


-- Q5. Find the beverage with the highest calories
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories
FROM starbucks_nutrition
ORDER BY calories DESC
LIMIT 1;


-- Q6. Find the top 10 highest-calorie beverages
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories
FROM starbucks_nutrition
ORDER BY calories DESC
LIMIT 10;


-- Q7. Find the beverage with the lowest calories
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories
FROM starbucks_nutrition
ORDER BY calories ASC
LIMIT 1;


-- Q8. Find beverages with more than 500 calories
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories
FROM starbucks_nutrition
WHERE calories > 500
ORDER BY calories DESC;


-- Q9. Find average calories by beverage category
SELECT beverage_category,
       ROUND(AVG(calories), 2) AS average_calories
FROM starbucks_nutrition
GROUP BY beverage_category
ORDER BY average_calories DESC;


-- Q10. Find total calories by beverage category
SELECT beverage_category,
       SUM(calories) AS total_calories
FROM starbucks_nutrition
GROUP BY beverage_category
ORDER BY total_calories DESC;


-- Q11. Find beverages with zero calories
SELECT beverage,
       beverage_category,
       beverage_prep
FROM starbucks_nutrition
WHERE calories = 0;


-- Q12. Find top 10 beverages with the highest sugar
SELECT beverage,
       beverage_category,
       beverage_prep,
       sugars_g
FROM starbucks_nutrition
ORDER BY sugars_g DESC
LIMIT 10;


-- Q13. Find average sugar by category
SELECT beverage_category,
       ROUND(AVG(sugars_g), 2) AS average_sugar
FROM starbucks_nutrition
GROUP BY beverage_category
ORDER BY average_sugar DESC;


-- Q14. Find beverages with high sugar (more than 50g)
SELECT beverage,
       beverage_category,
       sugars_g
FROM starbucks_nutrition
WHERE sugars_g > 50
ORDER BY sugars_g DESC;


-- Q15. Find beverages with less than 100 calories
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories
FROM starbucks_nutrition
WHERE calories < 100
ORDER BY calories;


-- Q16. Find top 10 high-protein beverages
SELECT beverage,
       beverage_category,
       beverage_prep,
       protein_g
FROM starbucks_nutrition
ORDER BY protein_g DESC
LIMIT 10;


-- Q17. Find average protein by category
SELECT beverage_category,
       ROUND(AVG(protein_g), 2) AS average_protein
FROM starbucks_nutrition
GROUP BY beverage_category
ORDER BY average_protein DESC;


-- Q18. Find beverages with more than 10g protein
SELECT beverage,
       beverage_category,
       protein_g
FROM starbucks_nutrition
WHERE protein_g > 10
ORDER BY protein_g DESC;


-- Q19. Find beverages with low calories and low sugar
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories,
       sugars_g
FROM starbucks_nutrition
WHERE calories < 100
  AND sugars_g < 10
ORDER BY calories, sugars_g;


-- Q20. Find high-calorie and high-sugar beverages
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories,
       sugars_g
FROM starbucks_nutrition
WHERE calories > 300
  AND sugars_g > 30
ORDER BY calories DESC, sugars_g DESC;


-- Q21. Find beverages with the highest sodium
SELECT beverage,
       beverage_category,
       sodium_mg
FROM starbucks_nutrition
ORDER BY sodium_mg DESC
LIMIT 10;


-- Q22. Find average sodium by category
SELECT beverage_category,
       ROUND(AVG(sodium_mg), 2) AS average_sodium
FROM starbucks_nutrition
GROUP BY beverage_category
ORDER BY average_sodium DESC;


-- Q23. Rank beverages by calories
SELECT beverage,
       beverage_category,
       beverage_prep,
       calories,
       RANK() OVER (ORDER BY calories DESC) AS calorie_rank
FROM starbucks_nutrition;


-- Q24. Find the highest calorie beverage in each category
SELECT beverage_category,
       beverage,
       beverage_prep,
       calories
FROM (
    SELECT beverage_category,
           beverage,
           beverage_prep,
           calories,
           RANK() OVER (
               PARTITION BY beverage_category
               ORDER BY calories DESC
           ) AS calorie_rank
    FROM starbucks_nutrition
) AS ranked_beverages
WHERE calorie_rank = 1
ORDER BY calories DESC;


-- Q25. Create a health category based on calories
SELECT beverage,
       beverage_category,
       calories,
       CASE
           WHEN calories < 100 THEN 'Low Calorie'
           WHEN calories BETWEEN 100 AND 300 THEN 'Medium Calorie'
           ELSE 'High Calorie'
       END AS calorie_category
FROM starbucks_nutrition
ORDER BY calories DESC;


-- Q26. Convert caffeine values to numeric and find top 10
SELECT beverage,
       beverage_category,
       caffeine_mg,
       CAST(
           NULLIF(
               REGEXP_REPLACE(caffeine_mg, '[^0-9.]', '', 'g'),
               ''
           ) AS NUMERIC
       ) AS caffeine_value
FROM starbucks_nutrition
ORDER BY caffeine_value DESC NULLS LAST
LIMIT 10;


-- Q27. Find average caffeine by category
SELECT beverage_category,
       ROUND(
           AVG(
               CAST(
                   NULLIF(
                       REGEXP_REPLACE(caffeine_mg, '[^0-9.]', '', 'g'),
                       ''
                   ) AS NUMERIC
               )
           ),
           2
       ) AS average_caffeine
FROM starbucks_nutrition
GROUP BY beverage_category
ORDER BY average_caffeine DESC NULLS LAST;




-- Q28. Display all stores
SELECT *
FROM starbucks_directory;


-- Q29. Count total Starbucks stores
SELECT COUNT(*) AS total_stores
FROM starbucks_directory;


-- Q30. Count stores by country
SELECT country,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY country
ORDER BY total_stores DESC;


-- Q31. Find top 10 countries with the most Starbucks stores
SELECT country,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY country
ORDER BY total_stores DESC
LIMIT 10;


-- Q32. Count stores by ownership type
SELECT ownership_type,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY ownership_type
ORDER BY total_stores DESC;


-- Q33. Find top 10 cities with the most Starbucks stores
SELECT city,
       country,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY city, country
ORDER BY total_stores DESC
LIMIT 10;


-- Q34. Count stores by state/province
SELECT state_province,
       country,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY state_province, country
ORDER BY total_stores DESC;


-- Q35. Find countries with more than 100 stores
SELECT country,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY country
HAVING COUNT(*) > 100
ORDER BY total_stores DESC;


-- Q36. Find company-owned stores
SELECT store_name,
       city,
       country,
       ownership_type
FROM starbucks_directory
WHERE ownership_type = 'Company Owned';


-- Q37. Find licensed stores
SELECT store_name,
       city,
       country,
       ownership_type
FROM starbucks_directory
WHERE ownership_type = 'Licensed';


-- Q38. Count stores in each country and ownership type
SELECT country,
       ownership_type,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY country, ownership_type
ORDER BY country, total_stores DESC;


-- Q39. Rank countries by number of stores
SELECT country,
       COUNT(*) AS total_stores,
       RANK() OVER (
           ORDER BY COUNT(*) DESC
       ) AS country_rank
FROM starbucks_directory
GROUP BY country
ORDER BY country_rank;


-- Q40. Find the country with the most stores
SELECT country,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY country
ORDER BY total_stores DESC
LIMIT 1;


-- Q41. Find cities with more than 50 stores
SELECT city,
       country,
       COUNT(*) AS total_stores
FROM starbucks_directory
GROUP BY city, country
HAVING COUNT(*) > 50
ORDER BY total_stores DESC;


-- Q42. Find stores with missing phone numbers
SELECT store_name,
       city,
       country
FROM starbucks_directory
WHERE phone_number IS NULL
   OR phone_number = '';


-- Q43. Find stores with missing postcode
SELECT store_name,
       city,
       country
FROM starbucks_directory
WHERE postcode IS NULL
   OR postcode = '';


-- Q44. Find stores in India
SELECT *
FROM starbucks_directory
WHERE country = 'IN';


-- Q45. Count stores in each Indian city
SELECT city,
       COUNT(*) AS total_stores
FROM starbucks_directory
WHERE country = 'IN'
GROUP BY city
ORDER BY total_stores DESC;


-- Q46. Find top 5 Indian cities by store count
SELECT city,
       COUNT(*) AS total_stores
FROM starbucks_directory
WHERE country = 'IN'
GROUP BY city
ORDER BY total_stores DESC
LIMIT 5;


-- Q47. Find the southernmost stores using latitude
SELECT store_name,
       city,
       country,
       latitude
FROM starbucks_directory
ORDER BY latitude ASC NULLS LAST
LIMIT 10;


-- Q48. Find the northernmost stores using latitude
SELECT store_name,
       city,
       country,
       latitude
FROM starbucks_directory
ORDER BY latitude DESC NULLS LAST
LIMIT 10;


-- Q49. Find the westernmost stores using longitude
SELECT store_name,
       city,
       country,
       longitude
FROM starbucks_directory
ORDER BY longitude ASC NULLS LAST
LIMIT 10;


-- Q50. Find the easternmost stores using longitude
SELECT store_name,
       city,
       country,
       longitude
FROM starbucks_directory
ORDER BY longitude DESC NULLS LAST
LIMIT 10;


-- View 1: Nutrition Summary
CREATE OR REPLACE VIEW vw_nutrition_summary AS
SELECT beverage_id,
       beverage_category,
       beverage,
       beverage_prep,
       calories,
       sugars_g,
       protein_g,
       sodium_mg,
       caffeine_mg,
       CASE
           WHEN calories < 100 THEN 'Low Calorie'
           WHEN calories BETWEEN 100 AND 300 THEN 'Medium Calorie'
           ELSE 'High Calorie'
       END AS calorie_category
FROM starbucks_nutrition;


-- View 2: Store Summary
CREATE OR REPLACE VIEW vw_store_summary AS
SELECT store_id,
       brand,
       store_number,
       store_name,
       ownership_type,
       city,
       state_province,
       country,
       longitude,
       latitude
FROM starbucks_directory;



-- Dashboard KPI 1: Total Beverages
SELECT COUNT(*) AS total_beverages
FROM starbucks_nutrition;


-- Dashboard KPI 2: Total Store Locations
SELECT COUNT(*) AS total_stores
FROM starbucks_directory;


-- Dashboard KPI 3: Average Beverage Calories
SELECT ROUND(AVG(calories), 2) AS average_calories
FROM starbucks_nutrition;


-- Dashboard KPI 4: Average Beverage Sugar
SELECT ROUND(AVG(sugars_g), 2) AS average_sugar
FROM starbucks_nutrition;


-- Dashboard KPI 5: Number of Countries
SELECT COUNT(DISTINCT country) AS total_countries
FROM starbucks_directory;


-- Dashboard KPI 6: Number of Cities
SELECT COUNT(DISTINCT city) AS total_cities
FROM starbucks_directory;


