# https://sqlzoo.net/wiki/More_JOIN_operations

1.SELECT id, title
 FROM movie
 WHERE yr=1962

2.select yr from movie where title = 'Citizen Kane'

3.select id, title, yr from movie where title LIKE '%Star Trek%'

4.select id from actor where name = 'Glenn Close'

5.select id from movie where title = 'Casablanca'

6.select name from actor where id in 
 (select casting.actorid from casting join movie on movie.id = casting.movieid where movie.title = 'Casablanca')

7.select name from actor where id in
(select actorid from casting where movieid =
(select id from movie where title = 'Alien'))

--select name from actor where id in 
 --(select casting.actorid from casting join movie on movie.id = casting.movieid where movie.title = -----'Alien')

8. select title from movie where id in 
(select movieid from casting where actorid =
(select id from actor where name = 'Harrison Ford'))

9.select title from movie where id in 
(select movieid from casting where actorid =
(select id from actor where name = 'Harrison Ford') and (ord !=1))
