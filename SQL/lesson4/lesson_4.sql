--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson4)
-- Корабли: Вывести список кораблей, у которых начинается с буквы "S"

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_with_flag_speed_price) над таблицей PC c флагом: flag = 1 для тех, у кого speed > 500 и price < 900, для остальных flag = 0
create view pc_with_flag_speed_price as 
(
	select
	*,
	case
		when p.speed > 500 and p.price < 900 then 1
		else 0
	end
	from pc p
)

select * from pc_with_flag_speed_price
--task3  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_maker_a) со всеми товарами производителя A. В view должны быть следующие колонки: model, price
create or replace view pc_maker_a as
(
	select
		prod.model
		, p.price 
	from product prod
	 join pc p on p.model = prod.model 
	where prod.maker = 'A'

	union
	select
		prod.model
		, p.price 
	from product prod
	 join printer p on p.model = prod.model 
	where prod.maker = 'A'
	
	union
	select
		prod.model
		, l.price 
	from product prod
	 join laptop l on l.model = prod.model 
	where prod.maker = 'A'
)
select * from pc_maker_a 
--task4 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы laptop (название: laptop_under_1000) и удалить из нее все товары с ценой выше 1000.
create table laptop_under_1000 as
(
	select
	*
	from laptop l 
	where l.price < 1000
)
select * from laptop_under_1000
--task5 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, с максимальной ценой и количеством по каждому производителю. (дубликаты можно учитывать).
create table all_products as
(
SELECT avg(price), max(price), count(*), maker
from 
(
SELECT price, maker
FROM laptop l 
join product p on l.model = p.model
union

SELECT price, maker
FROM pc l 
join product p on l.model = p.model
union

SELECT price, maker
FROM printer l 
join product p on l.model = p.model
) a
group by maker
order by avg 
)
select * from all_products
--task6 (lesson4)
-- Компьютерная фирма: Построить по all_products график в colab/jupyter (X: maker, Y: средняя цена)

--task7 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, с максимальной ценой продукта и количеством продуктов по каждому производителю. (дубликаты можно учитывать).

--task8 (lesson4)
-- Компьютерная фирма: Сделать view (название products_price_categories), в котором по всем продуктам нужно посчитать количество продуктов всего в зависимости от цены:
-- Если цена > 1000, то category_price = 2
-- Если цена < 1000 и цена > 500, то  category_price = 1
-- иначе category_price = 0
-- Вывести: category_price, count
create view products_price_categories as
(
	select count(*), category_price 
	from (select
		p.maker 
		, case 
			when p2.price > 1000 then 2
			when p2.price > 500 and p2.price < 1000 then 1
			else 0
		end category_price
	from product p
	join pc p2 on p2.model = p.model 
	
	union 
	select
		p.maker
		, case 
			when p2.price > 1000 then 2
			when p2.price > 500 and p2.price < 1000 then 1
			else 0
		end category_price
	from product p
	join printer p2 on p2.model = p.model 
	
	union 
	select
		p.maker
		, case 
			when l.price > 1000 then 2
			when l.price > 500 and l.price < 1000 then 1
			else 0
		end category_price
	from product p
	join laptop l on l.model = p.model) a
	group by category_price
)
select * from products_price_categories

--task9 (lesson4)
-- Сделать предыдущее задание, но дополнительно разбить еще по производителям (название products_price_categories_with_makers). Вывести: category_price, count, price

--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)

--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)
