--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
SELECT
*
FROM product p;

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", 
--у остальных - "0"
select 
	p.*
	, case 
		when p.price > (select avg(price) from pc) then 1
		else 0
	  end
from printer p 


--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select 
	o.ship
	, s."class" 
from outcomes o 
left join ships s on
	s."name"  = o.ship 
where s."class" is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
select * from battles b 
where date_part('year', b."date")
 not in (select
	distinct date_part('year', to_date(to_char(s.launched, '9999'), 'YYYY'))
from ships s)


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select
*
from outcomes o 
where o.ship in (select s."name" from ships s where s."class"='Kongo')


--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300.
-- Во view три колонки: model, price, flag
create or replace view all_products_flag_300 as
(
	select
		p.model 
		, p.price
		, case 
			when p.price > 300 then 1
			else 0
		  end flag
	from pc p

	union
	select
		pr.model 
		, pr.price
		, case 
			when pr.price > 300 then 1
			else 0
		  end flag 
	from printer pr
	
	union
	select
		l.model 
		, l.price
		, case 
			when l.price > 300 then 1
			else 0
		  end flag
	from laptop l 
)


--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, 
--если стоимость больше cредней . Во view три колонки: model, price, flag
create or replace view all_products_flag_300 as
(
	select
		p.model 
		, p.price
		, case 
			when p.price > (select avg(price) from pc) then 1
			else 0
		  end flag
	from pc p

	union
	select
		pr.model 
		, pr.price
		, case 
			when pr.price > (select avg(price) from printer) then 1
			else 0
		  end flag 
	from printer pr
	
	union
	select
		l.model 
		, l.price
		, case 
			when l.price > (select avg(price) from laptop) then 1
			else 0
		  end flag
	from laptop l 
)


--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select
	*
from 
	printer p
join product p2 on
	p2.model = p.model 
where 
	p2.maker in ('A')
	and p.price > 
		(select
			avg(price)
		from 
			printer p
		join product p2 on
			p2.model = p.model 
		where 
			p2.maker in ('D', 'C'))


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select
	p2.model 
from 
	product p2 
join pc p on
	p.model = p2.model 
where 
	p2.maker in ('A')
	and p.price > 
		(select
			avg(price)
		from 
			printer p
		join product p2 on
			p2.model = p.model 
		where 
			p2.maker in ('D', 'C'))
union
select
	p2.model 
from 
	product p2 
join printer p on
	p.model = p2.model 
where 
	p2.maker in ('A')
	and p.price > 
		(select
			avg(price)
		from 
			printer p
		join product p2 on
			p2.model = p.model 
		where 
			p2.maker in ('D', 'C'))
union 
select
	p2.model 
from 
	product p2 
join laptop l on
	l.model = p2.model 
where 
	p2.maker in ('A')
	and l.price > 
		(select
			avg(price)
		from 
			printer p
		join product p2 on
			p2.model = p.model 
		where 
			p2.maker in ('D', 'C'))
--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
select avg(price) from (
select
	p.price 
from 
	product p2 
join pc p on
	p.model = p2.model 
where 
	p2.maker in ('A')
union
select
	p.price 
from 
	product p2 
join printer p on
	p.model = p2.model 
where 
	p2.maker in ('A')
union 
select
	l.price 
from 
	product p2 
join laptop l on
	l.model = p2.model 
where 
	p2.maker in ('A')		
) a
--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create or replace view count_products_by_makers as
(
	select
		pr.maker maker
		, count(*) cnt
	from 
		product pr
	group by pr.maker 
)

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
SELECT maker, cnt
from count_products_by_makers
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df.cnt.to_list(), labels={'x':'maker', 'y':'count'})
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
create table printer_updated as 
(
	select
	p.*
	from printer p 
	join product p2 on p2.model = p.model 
	where p2.maker != 'D'
)

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create or replace view printer_updated_with_makers as
(
	select pu.*, p.maker from printer_updated pu
	join product p on p.model = pu.model
)
--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class
--(если значения класса нет/IS NULL, то заменить на 0)
create or replace view sunk_ships_by_classes as
(
	select a.* from (select 
		case 
			when s."class" is null then '0'
			else s."class" 
		end clas
		, count(*) 
	from outcomes o  
	left join ships s on s."name" = o.ship 
	where o."result" = 'sunk'
	group by s."class"
) a )
drop view sunk_ships_by_classes
--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, 
--иначе 0
create table classes_with_flag as 
(
	select
		c.*
		, case 
		  	when c.numguns >= 9 then 1
		  	else 0
		  end
	from classes c 
)
--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select
	count(*)
from ships s 
where s."name" like 'O%' or s."name" like 'M%'
--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select
	count(*)
from ships s 
where s."name" like '% %'
--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
