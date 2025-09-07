-- use book_scraper

select * from books_cleaned limit 10;
select * from books_cleaned where availability_flag = 0;
SELECT COUNT(*) FROM books_cleaned;
select * from books_cleaned;

-- drop table books_cleaned;

select avg(price) as avg_price from books_cleaned;
select title, price from books_cleaned order by price desc;
select title, price from books_cleaned order by price desc limit 1;
select availability_flag, count(*) from books_cleaned group by availability_flag;

select
avg(price) as avg_price,
min(price) as min_price,
max(price) as max_price
from books_cleaned;

select 
title, price 
from books_cleaned 
order by price desc limit 5;

select 
title, price 
from books_cleaned 
order by price asc limit 5;


SELECT 
    CASE 
        WHEN price < 10 THEN 'Under £10'
        WHEN price BETWEEN 10 AND 20 THEN '£10-£20'
        WHEN price BETWEEN 20 AND 40 THEN '£20-£40'
        ELSE 'Over £40'
    END AS price_range,
    COUNT(*) AS num_books
FROM books_cleaned
GROUP BY price_range
ORDER BY num_books DESC;


SELECT title, COUNT(*) 
FROM books_cleaned
GROUP BY title
HAVING COUNT(*) > 1;  -- we have a duplicate


