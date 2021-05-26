--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SELECT case when GRADE < 8 then NULL else NAME end, GRADE, MARKS
FROM STUDENTS s
JOIN GRADES g on S.Marks BETWEEN G.Min_Mark and G.Max_Mark
ORDER BY GRADE DESC, NAME;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select Doctor, Professor, Singer, Actor from
(
    select row_number() over (partition by occupation order by name) as rn, name, occupation from occupations
) occ
pivot
(
    max(name) for occupation in ('Doctor' as Doctor, 'Professor' as Professor, 'Singer' as Singer, 'Actor' as Actor)
)
order by rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct s.city from station s
where regexp_like(s.city, '^[^aeiouAEIOU].*');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct s.city from station s
where regexp_like(s.city, '*[^aeiouAEIOU]$');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct s.city from station s
where regexp_like(s.city, '^[^aeiouAEIOU]|*[^aeiouAEIOU]$');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct s.city from station s
where regexp_like(s.city, '^[^aeiouAEIOU].*[^aeiouAEIOU]$');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from employee
where salary > 2000 and months < 10;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
SELECT case when GRADE < 8 then NULL else NAME end, GRADE, MARKS
FROM STUDENTS s
JOIN GRADES g on S.Marks BETWEEN G.Min_Mark and G.Max_Mark
ORDER BY GRADE DESC, NAME;