# Netflix Movies and TV Shows Data Analysis using SQL

[Netflix Logo](https://github.com/saniya-collab/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## 15 Business Problems

### 1. Count the number of Movies v/s TV shows

```sql
SELECT  
	type, 
	COUNT(*) as total_content
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the most common rating for movies and TV Shows

```sql
SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	from netflix
GROUP BY 1,2
ORDER BY 1,3 desc;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List all movies released in a specific year (e.g., 2020)

```sql
SELECT title
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the top 5 countries with the most content on Netflix

```sql
SELECT country, COUNT(*) AS count
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY count DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the longest movie

```sql
SELECT title, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
LIMIT 1;
```

**Objective:** Find the movie with the longest duration.

### 6. Find content added in the last 5 years

```sql
SELECT title, date_added
FROM netflix
WHERE date_added IS NOT NULL 
AND EXTRACT(YEAR FROM date_added::date) >= EXTRACT(YEAR FROM CURRENT_DATE) - 5;
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find all the movies/TV shows by director 'Rajiv Chilaka'

```sql
SELECT show_id, title, type
FROM netflix
WHERE director = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List all TV shows with more than 5 seasons

```sql
SELECT show_id, title, duration
FROM netflix
WHERE type = 'TV Show' 
AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the number of content items in each genre

```sql
SELECT unnest(string_to_array(listed_in, ', ')) AS genre, COUNT(*) AS count
FROM netflix
GROUP BY genre
ORDER BY count DESC;
```
**Objective:** Count the number of content items in each genre.

### 10. Find each year and the average number of content releases in India on Netflix (Top 5)

```sql
SELECT release_year, COUNT(*) AS content_count
FROM netflix
WHERE country = 'India'
GROUP BY release_year
ORDER BY content_count DESC
LIMIT 5;
```
**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List all movies that are documentaries

```sql
SELECT title
FROM netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find all content without a director

```sql
SELECT title, type
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find how many movies actor 'Salman Khan' appeared in the last 10 years

```sql
SELECT COUNT(*) AS count
FROM netflix
WHERE type = 'Movie'
AND casts LIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

```sql
SELECT unnest(string_to_array(casts, ', ')) AS actor, COUNT(*) AS count
FROM netflix
WHERE country = 'India' AND type = 'Movie'
GROUP BY actor
ORDER BY count DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize the content based on 'kill' and 'violence' in the description

```sql
SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS count
FROM netflix
GROUP BY category;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.

