--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type
SELECT
*
FROM product p;

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", 
--� ��������� - "0"
select 
	p.*
	, case 
		when p.price > (select avg(price) from pc) then 1
		else 0
	  end
from printer p 


--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)
select 
	o.ship
	, s."class" 
from outcomes o 
left join ships s on
	s."name"  = o.ship 
where s."class" is null

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.
select * from battles b 
where date_part('year', b."date")
 not in (select
	distinct date_part('year', to_date(to_char(s.launched, '9999'), 'YYYY'))
from ships s)


--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
select
*
from outcomes o 
where o.ship in (select s."name" from ships s where s."class"='Kongo')


--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300.
-- �� view ��� �������: model, price, flag
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
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, 
--���� ��������� ������ c������ . �� view ��� �������: model, price, flag
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
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

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
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

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
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)
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
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count
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
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

request = """
SELECT maker, cnt
from count_products_by_makers
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df.cnt.to_list(), labels={'x':'maker', 'y':'count'})
fig.show()

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'
create table printer_updated as 
(
	select
	p.*
	from printer p 
	join product p2 on p2.model = p.model 
	where p2.maker != 'D'
)

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)
create or replace view printer_updated_with_makers as
(
	select pu.*, p.maker from printer_updated pu
	join product p on p.model = pu.model
)
--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class
--(���� �������� ������ ���/IS NULL, �� �������� �� 0)
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
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, 
--����� 0
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
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".
select
	count(*)
from ships s 
where s."name" like 'O%' or s."name" like 'M%'
--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.
select
	count(*)
from ships s 
where s."name" like '% %'
--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)
