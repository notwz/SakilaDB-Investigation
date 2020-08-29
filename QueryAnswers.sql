-- answers to investigating saklia dvdrental database. 
-- for: Udacity Project for Introduction to SQL course 


-- Query 1: 
-- Query that lists each movie, the film category it is calssified in,
-- and the number of times it has been rented out
-- Inspo : PSET 1 Q 1

"query:"

WITH t1 AS (SELECT *
            FROM category AS c
            JOIN film_category AS fc
            ON fc.category_id = c.category_id
            JOIN film AS f
            ON f.film_id = fc.film_id
            JOIN Inventory AS i
            ON i.film_id = f.film_id
            JOIN rental AS r
            ON i.inventory_id = r.inventory_id
            WHERE name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
            ORDER BY title)


SELECT title AS film_title, name AS category_name, COUNT(*) AS rental_count
		FROM t1
		GROUP BY 1,2
		ORDER BY category_name, film_title, rental_count DESC;

-- Query 2: 
-- provide table with move titles, divided into 4 levels
-- based on quartiles of the rental duration for movies across all categories.
-- Inspo : PSET 1 Q 2
"query:"

WITH t1 AS( SELECT * 
		FROM film f
		JOIN film_category fc
		ON f.film_id = fc.film_id
		JOIN category c
		ON fc.category_id = c.category_id
		JOIN inventory i
		ON i.film_id = f.film_id
		JOIN rental r
		ON r.inventory_id = i.inventory_id
		WHERE c.name = 'Animation' OR  c.name ='Children' 
		OR c.name ='Classics' OR  c.name ='Comedy' OR  c.name ='Family' 
		OR  c.name ='Music'
		)

SELECT 
	title,
	name,
	rental_duration,
	ntile(4) over (ORDER BY rental_duration) AS quartile

		FROM t1
		GROUP BY rental_duration, title, name 
		ORDER BY 3, 2 ,1

-- Query 3: 
-- table with shows the corresponding count of movies within each
-- combination of film category for each corresponding rental duration 
-- category. Include Category and Rental Length Category. 
-- Inspo : PSET 1 Q 3

"query:"

WITH t1 AS( 
	SELECT
	  c.name category_name,
	  NTILE(4) OVER (ORDER BY f.rental_duration) AS quartiles
		FROM film f
		JOIN film_category fc
		  ON f.film_id = fc.film_id
		JOIN category c
		  ON c.category_id = fc.category_id
		WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music') )

SELECT
	category_name,
	quartiles,
	COUNT(category_name)
		FROM t1
		GROUP BY 1, 2
		ORDER BY 1, 2

-- Query 4: 
-- query that returns the store ID, year, month, 
-- number of rental orders the store fufilled for that month
-- Inspo : PSET 2 Q 1
"query:"

SELECT
	DATE_PART('YEAR', rental_date) Rental_Year,
	DATE_PART('MONTH', rental_date) Rental_Month,
	s.store_id,
	COUNT(*)
			FROM rental r 
			JOIN payment p 
			  ON p.rental_id = r.rental_id
			JOIN staff st 
			  ON st.staff_id = p.staff_id
			JOIN store s
			  ON s.store_id = st.store_id
			GROUP BY 1,
			         2,
			         3
			order by 4 desc
