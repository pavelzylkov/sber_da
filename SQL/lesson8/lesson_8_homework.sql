--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select a.Department, a.employee, a.salary
from (         select 
                   dense_rank() over (partition by d.name order by e.salary desc) rn
                   , d.name Department
                   , e.name employee
                   , e.salary
               from employee e
               join 
                   department d on
                       d.id = e.DepartmentId) a
               
where a.rn <= 3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

SELECT fm.member_name, fm.status, sum(p.amount*p.unit_price) as costs FROM Payments p
join FamilyMembers fm on fm.member_id = p.family_member
WHERE year(p.date) = '2005'
GROUP BY p.family_member

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

SELECT p.name 
FROM Passenger P 
GROUP BY p.name
HAVING COUNT(p.name) >= 2

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from Student s
where s.first_name = 'Anna'
GROUP BY s.first_name

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(s.classroom) as count from Schedule S 
where date(s.date) = '2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

SELECT 
(
floor(avg((YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))))
    ) as age
from FamilyMembers fm

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

SELECT gt.good_type_name, sum(p.unit_price * p.amount) as costs
FROM Payments p 
join Goods g on g.good_id = p.good
join GoodTypes gt on gt.good_type_id = g.type
WHERE year(p.date) = '2005'
GROUP BY g.type

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

SELECT (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')) as year FROM Student S 
ORDER BY s.birthday DESC 
limit 1

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

SELECT (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')) as max_year FROM Student S 
join Student_in_class sic on sic.student = s.id
join class c on c.id = sic.class
where c.name like '10%'
ORDER BY s.birthday 
limit 1

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

SELECT fm.status, fm.member_name, sum(p.unit_price * p.amount) as costs
FROM Payments p
join FamilyMembers fm on fm.member_id = p.family_member 
join Goods g on g.good_id = p.good
join GoodTypes gt on gt.good_type_id = g.type
WHERE gt.good_type_name = 'entertainment'
GROUP BY fm.member_name, fm.status

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from company c where c.id in ( select a.company from (SELECT t.company company, count(*) as cnt
from Trip t 
group by t.company) A 
where a.cnt = (select min(a.cnt) from (SELECT t.company company, count(*) as cnt
from Trip t 
group by t.company) a))

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select a.classroom from (SELECT s.classroom, count(*) cnt from Schedule s 
GROUP BY s.classroom) a
ORDER BY a.cnt DESC 
limit 2

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

SELECT t.last_name from Schedule s
join subject sub on sub.id = s.subject
join teacher t on t.id = s.teacher
where sub.name = 'Physical Culture'
ORDER BY t.last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

SELECT concat(last_name,'.', substring(first_name,1,1),'.', substring(middle_name,1,1), '.') as name FROM Student S 
ORDER BY last_name, first_name, middle_name 