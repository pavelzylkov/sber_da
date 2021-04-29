--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select 
	s."class"
	, count(s.name) 
from 
	ships s 
join 
	outcomes o on o.ship = s."name" and o."result" = 'sunk'
group by 
	s."class" 
	
--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select
	distinct on (c."class") 
	c."class" 
	, s.launched 
from ships s 
left join 
	classes c on c."class" = s."class" 
order by c."class", s.launched asc 
--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

select
	s."class" 
from ships s 
where 
	s.name in (
		select 
			o.ship 
		from ships s
		right join 
			outcomes o on o.ship = s."name"
		where 
			o."result" = 'sunk'
			)
and 
	(s."class", 1) in (
		select
			s."class" 
			, case 
				when count(s.name) > 3 then 1
				else 0
			  end
		from 
			ships s 
		group by
			s."class"
			           )


	
--task4
--Корабли: Найдите названия кораблей, 
--имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).
select
	s."name" 
from 
	ships s
join classes c 
	on c."class" = s."class"
left join outcomes o 
	on o.ship = s."name" 
where
	(c.numguns , c.displacement) in (
select
	max(c.numguns) 
	, c.displacement 
from 
	classes c 
group by c.displacement )
--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
select
	distinct pr.maker 
from product pr
where pr."type"  = 'Printer'
and pr.maker in (select p2.maker from pc p
					join product p2 on p2.model = p.model 
					where p.speed in (select max(p.speed) from pc p where 
												p.ram = (select min(p.ram) from pc p)
												)
					)
