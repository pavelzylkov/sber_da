--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко
import sqlite3
conn = sqlite3.connect('task1_7.db')  
c = conn.cursor()

request = "CREATE TABLE test(col1 int, col2 int, col3 int)"
c.execute(request)
tables = c.fetchall()

SELECT * from test t 

insert into test
with recursive rand(x, y, z) as (
	values(abs(random() % 1000), abs(random() % 1000), abs(random() % 1000)) union all
	select abs(random() % 1000), abs(random() % 1000), abs(random() % 1000) from rand
	limit 1000
)
select * from rand;

import plotly.express as px
import pandas as pd
request = 'select * from test'
df = pd.read_sql_query(request, conn)
fig = px.histogram(df, nbins=1000, barmode='stack')
fig.show()
--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select p.email from Person p 
group by p.email
having count(*) > 1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select e.Name as Employee
from employee e
join employee m on m.id = e.ManagerId
where e.salary > m.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score, dense_rank() over(order by score desc) as Rank from scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/
select
    p.FirstName
    , p.LastName
    , a.City
    , a.State
from
    person p
left join address a
    on a.PersonId = p.PersonId
