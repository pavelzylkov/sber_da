--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц
create or replace view pages_all_products as ( 
	SELECT *, 
      CASE WHEN num % 2 = 0 THEN num/2 ELSE num/2 + 1 END AS page_num, 
      CASE WHEN total % 2 = 0 THEN total/2 ELSE total/2 + 1 END AS num_of_pages
FROM (
      SELECT *, ROW_NUMBER() OVER(ORDER BY price DESC) AS num, 
             COUNT(*) OVER() AS total 
      FROM Laptop
     ) X
)


--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель,

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но у название корабля должно состоять из двух слов
create table ships_two_words as ( 
	select 
		*
	from ships s 
	where s."name" like '% %'
)


--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

	select 
		*
	from ships s 
	where s."name" like 'S%' and s."class" is null

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

select * from (
	select 
		*
		, row_number() over (order by p.price DESC) as rn 
	from
		printer p 
	join 
		product p2 
			on p2.model = p.model 
	where 
		p2.maker = 'A'
		and p.price > (select case when avg(p.price) is null then 0 else avg(p.price) end from printer p 
					   join product p2 on p2.model = p.model 
					   where p2.maker = 'C')
) a
where rn <=3
    
	