USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name , table_rows
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_SCHEMA = 'imdb';









-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT * FROM movie
WHERE languages is null or country is null or worlwide_gross_income is null or production_company is null;










-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
select year, count(*) as number_of_movies 
from movie 
group by year 
order by year;
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select month(date_published) as month_num , count(*) as number_of_movies
from movie
group by month_num
order by month_num
 ;








/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select country, count(*) as number_of_movies from movie
where country in ('usa' , 'india') and year = '2019'
group by country;









/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select Distinct genre from genre;










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select count(*) as number_of_movie , genre from
movie m inner join genre g on m.id = g.movie_id
where year = '2019'
group by genre 
order by count(*) desc limit 1;









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
select count(*) as number_of_movie , genre from
movie m inner join genre g on m.id = g.movie_id
group by genre 
order by count(*) desc limit 1;

SELECT COUNT(*) AS count
FROM (
  SELECT movie_id
  FROM movie
  JOIN genre ON movie.id = genre.movie_id
  GROUP BY movie_id
  HAVING COUNT(*) = 1
) AS temp;

  



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/



-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select  genre ,avg(duration) as avg_duration  from genre g
inner join movie m on g.movie_id = m.id
group by genre 
order by avg_duration desc;








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select genre, count(*) as movie_count , 
rank() over(order by count(*) desc) as genre_rank
from genre g
inner join movie m on g.movie_id = m.id
group by genre;









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select min(avg_rating) as min_avg_rating , max(avg_rating) as max_avg_rating,
       min(total_votes) as min_total_votes ,  max(total_votes) as max_total_votes,
       min(median_rating) as min_median_rating , max(median_rating) as max_median_rating
       from ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
select TITLE , AVG_RATING , RANK() OVER(ORDER BY AVG_RATING DESC ) AS MOVIE_RANK
FROM MOVIE M INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
LIMIT 10









/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT MEDIAN_RATING, COUNT(*) AS MOVIE_COUNT FROM
MOVIE M INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
GROUP BY MEDIAN_RATING
ORDER BY COUNT(*) DESC;







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT PRODUCTION_COMPANY , COUNT(*) AS MOVIE_COUNT , RANK() OVER(ORDER BY COUNT(*) DESC)
FROM MOVIE M INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE AVG_RATING > 8
GROUP BY PRODUCTION_COMPANY;








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT GENRE , COUNT(*) AS MOVIE_COUNT FROM
MOVIE M INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
WHERE MONTH(DATE_PUBLISHED) = 3 AND YEAR = '2017'
GROUP BY GENRE ;






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT TITLE , AVG_RATING , GENRE FROM MOVIE M
INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
INNER JOIN GENRE G ON G.MOVIE_ID = M.ID
WHERE TITLE LIKE 'THE%' AND AVG_RATING > 8
;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(*) AS MOVIE_COUNT FROM MOVIE M
INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01' 
AND MEDIAN_RATING = 8








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT COUNT(*) AS MOVIE_COUNT , LANGUAGES , SUM(TOTAL_VOTES) AS TOTAL_VOTES
FROM MOVIE M INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE LANGUAGES IN ('GERMAN','ITALIAN')
GROUP BY LANGUAGES; 







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(*) AS NAME_NULLS FROM NAMES WHERE NAME IS NULL;
SELECT COUNT(*) AS HEIGHT_NULLS FROM NAMES WHERE HEIGHT IS NULL;
SELECT COUNT(*) AS DATE_OF_BIRTH_NULLS FROM NAMES WHERE DATE_OF_BIRTH IS NULL;
SELECT COUNT(*) AS KNOWN_FOR_MOVIES_NULLS FROM NAMES WHERE KNOWN_FOR_MOVIES IS NULL;

SELECT NAME_NULLS , HEIGHT_NULLS FROM(
SELECT COUNT(*) AS NAME_NULLS FROM NAMES WHERE NAME IS NULL) AS T;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT NAME AS DIRECTOR_NAME, COUNT(*) AS MOVIES_COUNT FROM 
MOVIE M INNER JOIN GENRE G ON M.ID = G.MOVIE_ID 
INNER JOIN DIRECTOR_MAPPING D ON D.MOVIE_ID = M.ID
INNER JOIN NAMES N ON N.ID = D.NAME_ID
INNER JOIN RATINGS R ON R.MOVIE_ID = M.ID
WHERE GENRE IN ('DRAMA','ACTION','COMEDY') AND AVG_RATING > 8
GROUP BY DIRECTOR_NAME
ORDER BY MOVIES_COUNT DESC LIMIT 3;


SELECT GENRE , count(*) as movie_count FROM MOVIE M
INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
inner join ratings r on r.movie_id = m.id
where avg_rating >8
GROUP BY GENRE 
 ORDER BY COUNT(*) DESC LIMIT 3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT NAME AS ACTOR_NAME, COUNT(*) AS MOVIE_COUNT FROM
MOVIE M INNER JOIN ROLE_MAPPING RO ON  M.ID = RO.MOVIE_ID 
INNER JOIN NAMES N ON N.ID = RO.NAME_ID
INNER JOIN RATINGS R ON R.MOVIE_ID = M.ID
WHERE MEDIAN_RATING >= 8
GROUP BY ACTOR_NAME
ORDER BY COUNT(*) DESC LIMIT 2;




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT PRODUCTION_COMPANY , SUM(TOTAL_VOTES) AS VOTE_COUNT, RANK() OVER(ORDER BY SUM(TOTAL_VOTES) DESC) AS PROD_COMP_RANK
FROM MOVIE M INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
GROUP BY PRODUCTION_COMPANY;









/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT * FROM MOVIE;
SELECT * FROM NAMES;
SELECT * FROM ROLE_MAPPING;

SELECT  NAME AS ACTOR_NAME , SUM(R.TOTAL_VOTES) AS TOTAL_VOTES , COUNT(*) AS MOVIE_COUNT , AVG(R.TOTAL_VOTES) AS ACTOR_AVG_RATING,
RANK() OVER(ORDER BY AVG(AVG_RATING *TOTAL_VOTES) DESC) AS ACTOR_RANK
FROM MOVIE M  JOIN RATINGS R ON M.ID = R.MOVIE_ID
 JOIN ROLE_MAPPING RO ON RO.MOVIE_ID = M.ID
 JOIN NAMES N ON N.ID = RO.NAME_ID
 WHERE COUNTRY = 'INDIA' AND CATEGORY = 'ACTOR'
GROUP BY ACTOR_NAME
HAVING COUNT(*) >= 5;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT  NAME AS ACTOR_NAME , SUM(R.TOTAL_VOTES) AS TOTAL_VOTES , COUNT(*) AS MOVIE_COUNT , AVG(R.TOTAL_VOTES*AVG_RATING/R.TOTAL_VOTES) AS ACTOR_AVG_RATING,
RANK() OVER(ORDER BY AVG(R.TOTAL_VOTES*AVG_RATING/R.TOTAL_VOTES) DESC) AS ACTOR_RANK
FROM MOVIE M  JOIN RATINGS R ON M.ID = R.MOVIE_ID
 JOIN ROLE_MAPPING RO ON RO.MOVIE_ID = M.ID
 JOIN NAMES N ON N.ID = RO.NAME_ID
 WHERE COUNTRY = 'INDIA' AND CATEGORY = 'ACTRESS'
GROUP BY ACTOR_NAME
HAVING COUNT(*) >= 3;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title, 
    CASE 
        WHEN  avg_rating > 8 THEN 'Superhit movies'
        WHEN  avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN  avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies' 
    END as movie_category
FROM movie M INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
WHERE genre = 'Thriller'

ORDER BY avg_rating DESC;









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT g.GENRE , AVG(m.DURATION) AS AVG_DURATION , sum(m.duration) OVER (PARTITION BY g.movie_id ORDER BY m.date_published ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_duration,
AVG(duration) OVER (ORDER BY date_published ROWS BETWEEN unbounded PRECEDING AND CURRENT ROW) AS moving_avg_duration
from movie m inner join genre g on m.id = g.movie_id
group by genre;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT distinct GENRE, YEAR  ,  TITLE , WORLWIDE_GROSS_INCOME , ROW_NUMBER() OVER (PARTITION BY year ORDER BY  WORLWIDE_GROSS_INCOME DESC) AS MOVIE_RANK
FROM MOVIE M INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
WHERE YEAR = 2017  AND GENRE IN ('DRAMA','COMEDY','THRILLER') 
ORDER BY  WORLWIDE_GROSS_INCOME DESC limit 5; 

SELECT distinct GENRE, YEAR  ,  TITLE , WORLWIDE_GROSS_INCOME , ROW_NUMBER() OVER (PARTITION BY year ORDER BY  WORLWIDE_GROSS_INCOME DESC) AS MOVIE_RANK
FROM MOVIE M INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
WHERE YEAR = 2018  AND GENRE IN ('DRAMA','COMEDY','THRILLER') 
ORDER BY  WORLWIDE_GROSS_INCOME DESC limit 5;

SELECT distinct GENRE, YEAR  ,  TITLE , WORLWIDE_GROSS_INCOME , ROW_NUMBER() OVER (PARTITION BY year ORDER BY  WORLWIDE_GROSS_INCOME DESC) AS MOVIE_RANK
FROM MOVIE M INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
WHERE YEAR = 2019  AND GENRE IN ('DRAMA','COMEDY','THRILLER') 
ORDER BY  WORLWIDE_GROSS_INCOME DESC limit 5;

-- sorry i cant find a code to do it in single line


-- Top 3 Genres based on most number of movies
SELECT GENRE , COUNT(*) AS MOVIE_COUNT FROM MOVIE M
INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
GROUP BY GENRE 
ORDER BY MOVIE_COUNT
DESC LIMIT 3









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, count(*) as movie_count , rank() over(order by count(*) desc) as  prod_comp_rank
from movie m inner join ratings r on m.id = r.movie_id
where median_rating >= 8 and POSITION(',' IN languages) > 0
group by production_company
order by movie_count desc limit 2;







-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select name as actress_name , sum(total_votes) as total_votes , count(*) as movie_count , avg(total_votes*avg_rating/total_votes) as actress_avg_rating ,
rank() over(order by avg(total_votes) desc) as actress_rank
from MOVIE M  JOIN RATINGS R ON M.ID = R.MOVIE_ID
 JOIN ROLE_MAPPING RO ON RO.MOVIE_ID = M.ID
 JOIN NAMES N ON N.ID = RO.NAME_ID
 where category = 'actress'
 group by name
 order by avg(total_votes) desc limit 3;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
select n.name as director_name , count(*) as movie_count , avg(datediff(m2.date_published , m1.date_published)) as avg_inter_movie_days,
avg(r.avg_rating) , sum(r.total_votes) , min(r.avg_rating) as min_rating , max(r.avg_rating) as max_rating , sum(m1.duration) as total_duration
from movie as m1 inner join director_mapping d on m1.id = d.movie_id
inner join names n on n.id = d.name_id
inner join movie as m2 on d.movie_id = m2.id
inner join ratings r on r.movie_id = m1.id
and m2.date_published > m1.date_published
group by director_name;







