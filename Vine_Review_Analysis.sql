-- Filter dataframe to retrieve all rows where total_votes count is greater than or equal to 20
CREATE TABLE total_votes_20 AS
SELECT *
FROM vine_table
WHERE total_votes >= 20;

-- Filter previous table to create a new table that retrieves rows where helpful_votes divided by total_votes is equal to or greater than 50%
CREATE TABLE total_votes_50percent AS
SELECT *
FROM total_votes_20
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >= 0.5;

-- Filter previous table and create new table that retrieves all rows where the review was part of the Vine program(paid)
CREATE TABLE vine_paid AS
SELECT *
FROM total_votes_50percent
WHERE vine = 'Y';

-- Filter previous table and create new table that retrieves all rows where the review was not part of the Vine program(unpaid)
CREATE TABLE vine_unpaid AS
SELECT *
FROM total_votes_50percent
WHERE vine = 'N';

-- Determine total paid reviews
CREATE TABLE total_paid_reviews AS
SELECT COUNT(total_votes) AS total_paid_reviews
FROM vine_paid;

-- Determine total paid 5 star reviews
CREATE TABLE total_paid_5_star_reviews AS
SELECT COUNT(total_votes) AS total_paid_5_star_reviews
FROM vine_paid
where star_rating = 5;

-- Determine percentage of paid 5 star reviews
CREATE TABLE paid_review_analysis AS
SELECT tpr.total_paid_reviews, tpfs.total_paid_5_star_reviews,
CAST(tpfs.total_paid_5_star_reviews AS FLOAT) / CAST(tpr.total_paid_reviews AS FLOAT) * 100 AS percent_5_star_paid
FROM total_paid_reviews AS tpr
INNER JOIN total_paid_5_star_reviews AS tpfs
ON 1=1;

-- Determine total unpaid reviews
CREATE TABLE total_unpaid_reviews AS
SELECT COUNT(total_votes) AS total_unpaid_reviews
FROM vine_unpaid;

-- Determine total paid 5 star reviews
CREATE TABLE total_unpaid_5_star_reviews AS
SELECT COUNT(total_votes) AS total_unpaid_5_star_reviews
FROM vine_unpaid
where star_rating = 5;

-- Determine percentage of paid 5 star reviews
CREATE TABLE unpaid_review_analysis AS
SELECT tur.total_unpaid_reviews, tufs.total_unpaid_5_star_reviews,
CAST(tufs.total_unpaid_5_star_reviews AS FLOAT) / CAST(tur.total_unpaid_reviews AS FLOAT) * 100 AS percent_5_star_unpaid
FROM total_unpaid_reviews AS tur
INNER JOIN total_unpaid_5_star_reviews AS tufs
ON 1=1;