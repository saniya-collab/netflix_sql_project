--Netflix Project
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(210),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

SELECT * from netflix;

SELECT 
	DISTINCT type
FROM netflix;

--15 Business Problems

-- Count the number of Movies v/s TV shows

SELECT  
	type, 
	COUNT(*) as total_content
FROM netflix
GROUP BY type;

--Find the most common rating for movies and TV Shows

SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	from netflix
GROUP BY 1,2
ORDER BY 1,3 desc;

--List all movies released in a specific year (e.g., 2020)

SELECT title
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

--Find the top 5 countries with the most content on Netflix

SELECT country, COUNT(*) AS count
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY count DESC
LIMIT 5;

--Identify the longest movie

SELECT title, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
LIMIT 1;

--Find content added in the last 5 years

SELECT title, date_added
FROM netflix
WHERE date_added IS NOT NULL 
AND EXTRACT(YEAR FROM date_added::date) >= EXTRACT(YEAR FROM CURRENT_DATE) - 5;

--Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT show_id, title, type
FROM netflix
WHERE director = 'Rajiv Chilaka';

--List all TV shows with more than 5 seasons

SELECT show_id, title, duration
FROM netflix
WHERE type = 'TV Show' 
AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;

--Count the number of content items in each genre

SELECT unnest(string_to_array(listed_in, ', ')) AS genre, COUNT(*) AS count
FROM netflix
GROUP BY genre
ORDER BY count DESC;

--Find each year and the average number of content releases in India on Netflix (Top 5)

SELECT release_year, COUNT(*) AS content_count
FROM netflix
WHERE country = 'India'
GROUP BY release_year
ORDER BY content_count DESC
LIMIT 5;

--List all movies that are documentaries

SELECT title
FROM netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';

--Find all content without a director

SELECT title, type
FROM netflix
WHERE director IS NULL;

--Find how many movies actor 'Salman Khan' appeared in the last 10 years

SELECT COUNT(*) AS count
FROM netflix
WHERE type = 'Movie'
AND casts LIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT unnest(string_to_array(casts, ', ')) AS actor, COUNT(*) AS count
FROM netflix
WHERE country = 'India' AND type = 'Movie'
GROUP BY actor
ORDER BY count DESC
LIMIT 10;

--Categorize the content based on 'kill' and 'violence' in the description

SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS count
FROM netflix
GROUP BY category;













