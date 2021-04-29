--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson4)
-- �������: ������� ������ ��������, � ������� ���������� � ����� "S"

--task2  (lesson4)
-- ������������ �����: ������� view (��������: pc_with_flag_speed_price) ��� �������� PC c ������: flag = 1 ��� ���, � ���� speed > 500 � price < 900, ��� ��������� flag = 0
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
-- ������������ �����: ������� view (��������: pc_maker_a) �� ����� �������� ������������� A. � view ������ ���� ��������� �������: model, price
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
-- ������������ �����: ������� ����� ������� laptop (��������: laptop_under_1000) � ������� �� ��� ��� ������ � ����� ���� 1000.
create table laptop_under_1000 as
(
	select
	*
	from laptop l 
	where l.price < 1000
)
select * from laptop_under_1000
--task5 (lesson4)
-- ������������ �����: ������� ����� ������� (��������: all_products) �� ������� ���������� ���� ���������, � ������������ ����� � ����������� �� ������� �������������. (��������� ����� ���������).
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
-- ������������ �����: ��������� �� all_products ������ � colab/jupyter (X: maker, Y: ������� ����)

--task7 (lesson4)
-- ������������ �����: ������� ����� ������� (��������: all_products) �� ������� ���������� ���� ���������, � ������������ ����� �������� � ����������� ��������� �� ������� �������������. (��������� ����� ���������).

--task8 (lesson4)
-- ������������ �����: ������� view (�������� products_price_categories), � ������� �� ���� ��������� ����� ��������� ���������� ��������� ����� � ����������� �� ����:
-- ���� ���� > 1000, �� category_price = 2
-- ���� ���� < 1000 � ���� > 500, ��  category_price = 1
-- ����� category_price = 0
-- �������: category_price, count
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
-- ������� ���������� �������, �� ������������� ������� ��� �� �������������� (�������� products_price_categories_with_makers). �������: category_price, count, price

--task10 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� ������� ������������� ������ (X: category_price, Y: count)

--task11 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� A & D ������ (X: category_price, Y: count)

--task12 (lesson4)
-- �������: ������� ����� ������� ships, �� � �������� ������� �� ������ ���������� � ����� N (ships_without_n)
