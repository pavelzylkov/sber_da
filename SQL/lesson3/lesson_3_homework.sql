--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������. �������: ����� � ����� ����������� ��������.
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
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. ���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������. �������: �����, ���.
select
	distinct on (c."class") 
	c."class" 
	, s.launched 
from ships s 
left join 
	classes c on c."class" = s."class" 
order by c."class", s.launched asc 
--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������, ������� ��� ������ � ����� ����������� ��������.

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
--�������: ������� �������� ��������, 
--������� ���������� ����� ������ ����� ���� �������� ������ �� ������������� (������ ������� �� ������� Outcomes).
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
--������������ �����: ������� �������������� ���������, ������� ���������� �� � ���������� ������� RAM � � ����� ������� ����������� ����� ���� ��, ������� ���������� ����� RAM. �������: Maker
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
