-- mega assignment question-SQL
use market_star_schema;

-- Q-1> Need the full details of shipment so select order id, shipid, shipping-cost, ship-date from the database. 
select s.Order_ID, s.ship_id, s.ship_Date, m.shipping_cost from shipping_dimen as s left join market_fact_full as m
on s.Ship_id = m.Ship_id;
-- q-2> provide the customer name, city, state and the order Id and order quantity they ordered. 
-- sol>
select c.customer_Name, c.city, c.state, m.Ord_id, m.Order_quantity from cust_dimen as c left join market_fact_full as m
on c.cust_id = m.cust_id;
-- q-3> provide the product details like order id, shipment id whose shipment mode is Regular air. 
-- sol>
select Order_ID, ship_id, ship_Mode from shipping_dimen where ship_Mode ='Regular air';
-- q-4> From order_dimen table order having order_priority as critical and high change it to Immediate delivery and all other to normal delivery. 
-- sol>
select Ord_id, Order_number, Order_Date, Order_Priority,
      case
          when Order_priority ='critical' or Order_priority ='high'
          then 'Immediate delivery'
          else 'normal delivery'
          end as Order_delivery
          from Orders_dimen; 
          
-- q-5> provide all the details of customers which are from west bengal. 
-- sol>
select* from cust_dimen
where state = 'West Bengal';
-- q-6> provide the order details like ord_id, prod_id, ship_id, cust_id whose discount is more than 0.05 and order_quantity is more than 10. 
select* from market_fact_full
where Discount > '0.05' and Order_quantity > '10';
-- q-7,8> Create a table shipping _mode_dimen having columns with their respective data type as the following:-
-- i> ship_mode VARCHAR(25)
-- ii> Vechicle_company VARCHAR(25)
-- iii> Tool_require BOOLEAN
-- sol>
create table shipping_mode_dimen
(
ship_mode VARCHAR (25)  NOT NULL PRIMARY KEY,
Vechicle_company VARCHAR (25)  NOT NULL,
Toll_Required BOOLEAN  NOT NULL
);
-- q-9>Insert two rows in the table created above having the row-wise values. 
-- i>DELIVERY TRUCK, ASHOK LEYLAND,false. 
-- ii> Regular air, Air india, false. 
-- sol>
insert into shipping_mode_dimen(ship_mode, Vechicle_company, Toll_Require)
VALUES 
("DELIVERY TRUCK", "Ashok leyland", "false"),
("Regular air", "Air india", "false");
-- q-10> Add another column name vechicle number and its data type to the created table. 
-- sol>
alter table shipping_mode_dimen
add vechicle_number varchar(20);
-- q-11> update its value to 'MH-05-1234.
 insert into shipping_mode_dimen(vechicle_number)
 values ('MH-05-R1234');

-- q-12> print the name of all the customer who are either corporate or belong to Mumbai.
-- sol> 
select Customer_Name,City,customer_segment from cust_dimen where city = 'Mumbai' or customer_segment = 'CORPORATE';
-- q-13> find the total number of sales made. 
-- sol>
select count(sales) as total_no_of_sales from market_fact_full;
-- q-14> what are the total number of customers from each city. 
-- sol>
select count(customer_name) as total_no_of_customer,city from cust_dimen
group by city;
-- q-15> list the customers name in alphabetical order. 
-- sol>
select distinct( customer_name) from cust_dimen order by customer_name;
-- q-16> print the three most ordered products. 
-- sol>
select prod_id,sum(order_quantity)
from market_fact_full
group by prod_id
order by sum(order_quantity)desc
limit 3;
-- q-17> which month and year combination saw the most number of critical order. 
-- sol>
select count(ord_id) as order_count,month(order_date) as order_month,
year(order_date) as order_year
from orders_dimen
where order_priority='critical'
group by order_year,order_month
order by order_count desc;
-- q-18> find the most commonly used mode of shipment in 2011. 
-- sol> 
select ship_mode,count(ship_mode) as ship_mode_count,ship_date
from shipping_dimen
where year(ship_date)=2011
group by ship_mode
order by ship_mode_count desc;
-- q-19> print the name of the most frequent customer. 
-- sol>
select customer_name,cust_id
from cust_dimen
where cust_id=(
select cust_id
from market_fact_full
group by cust_id
order by count(cust_id)desc
limit 1
);
-- q-20> find all low- priority orders made in month of april.out of them, how many were made in the first half of the month. 
-- sol> 
with low_priority_orders as(
select ord_id,order_date,order_priority
from orders_dimen
where order_priority='low' and month(order_date)=4
)
select count(ord_id)as order_count
from low_priority_orders
where day(order_date)between 1 and 15;
-- q-21> Rank the orders made by Aron Smayling in the decreasing order of the resulting sales. 
-- sol>
select customer_name,
          ord_id,
          ROUND(sales)as rounded_sales,
	RANK() OVER(ORDER BY sales desc) as sales_rank
    from market_fact_full as m
    INNER JOIN
    cust_dimen as c
    on m.cust_id=c.cust_id
    where customer_name='Aaron smayling';
-- q-22> For the above customer,rank the orders in the increasing order of the discount provided.Also display the dense rank. 
-- sol>
select ord_id,discount,customer_name,
rank() over(order by discount asc)as disc_dense_rank
from market_fact_full as m
inner join cust_dimen as c
on m.cust_id=c.cust_id
where customer_name='Aaron Smayling';
-- q-23> Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron smayling.Also display the
-- row numbers for each order. 
-- sol> 
select customer_name,
count(distinct ord_id) as order_count,
rank() over (order by count(distinct ord_id) asc) as order_rank,
dense_rank()over(order by count(distinct ord_id) asc) as
order_dense_rank,
row_number()over(order by count(distinct ord_id) asc) as
order_row_num
from market_fact_full as m
inner join
cust_dimen as c
on m.cust_id=c.cust_id
where customer_name='Aaron Smayling'
group by customer_name;






