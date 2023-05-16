-- create table statement
CREATE TABLE purchases_per_day(
    product INT not null,
    province INT not null,
    qty INT not null,
    time INT not null,
    cnt INT not null
);

create table Dates(
    time int not null
);

-- insert table statement
insert into purchases_per_day (product, province, qty, time, cnt)
with maxTime as (
	select date(COALESCE(max(time), 0), '+10 days') as maxTime
    from Dates
) select product, province, qty, time, count(*) as cnt
from
	Purchases P
    join maxTime M on P.time > M.maxTime
group by product, province, qty, time;

insert into Dates (time)
select date(max(time), '-10 days')
from purchases_per_day;

-- 1. 
with purchasesPerProvince as (
    select province, sum(cnt) as cnt
    from
        purchases_per_day
    group by province
), orderedProvince as (
    select country, ROWID
    from
        Province
), tenMax as (
select country, sum(cnt) as cnt
from
    purchasesPerProvince T
    join orderedProvince O on T.province = O.ROWID
group by country
order by cnt desc
limit 10
), reducedCountry as (
    select code, name
    from Country
)
    select C.name as country, cnt
from
    tenMax T
    join reducedCountry C on T.country = C.code

-- 2.
select product, sum(cnt) as cnt
from purchases_per_day
group by product;

-- 3.
with zeroPurchases as (
    select province, sum(cnt) as cnt
    from purchases_per_day
    where product = 0
    group by province
),
zeroPurchasesPerProvince as (
    select P.country as country, P.name as province, Z.cnt as cnt
    from
        zeroPurchases Z
        join Province P on P.ROWID = Z.province
),
zeroPurchasesPerCountry as (
    select country, sum(cnt) as cnt
    from
        zeroPurchasesPerProvince
    group by country
),
double as (
    select Z1.country, Z1.province, Z1.cnt
    from
        zeroPurchasesPerProvince Z1
        join zeroPurchasesPerProvince Z2 on Z1.country = Z2.country
    where Z1.cnt < Z2.cnt
),
filtered as (
    select country, province, cnt from zeroPurchasesPerProvince
    except
    select country, province, cnt from double
)
select C.name as country, F.province as province, F.cnt as cnt, F.cnt * 1.0 / Z.cnt as ratio
from
    filtered F
    join zeroPurchasesPerCountry Z on Z.country = F.country
    join Country C on C.code = F.country;

-- 4.
with encompassesFull as (
    select continent, country
    from Encompasses
    where percentage = 100
), purchasesPerQtyPerProvince as (
    select province, qty, sum(cnt) as cnt
    from purchases_per_day
    group by province, qty
), purchasesPerQtyPerCountry as (
    select country, qty, sum(cnt) as cnt
    from
        purchasesPerQtyPerProvince
        join Province P on province = P.ROWID
    group by country, qty
)
select continent, qty, sum(cnt) as cnt
from encompassesFull E
    join purchasesPerQtyPerCountry P on P.country = E.country
group by continent, qty;

-- 5.
with maxTime as (
    select max(time) as maxTime
    from Dates
)
select product, sum(cnt) as cnt
from 
    purchases_per_day
    join maxTime M on time > M.maxTime
group by product

-- 6.
with maxTime as (
    select max(time) as maxTime
    from Dates
)
select time, sum(cnt) as cnt
from
    purchases_per_day
    join maxTime on time > maxTime
group by time;

-- 7.
with provinceBrabant as (
    select ROWID from Province where name = 'Brabant'
),
purchaseBrabant as (
    select id, time
    from
        Purchases
        join provinceBrabant on provinceBrabant.ROWID = province
)
select id
from purchaseBrabant where time = (select date(max(time), '+10 days') as maxTime from Dates);

-- 8.
with provinceVienna as (
    select ROWID from Province where name = 'Vienna'
),
purchaseVienna as (
    select id, time
    from
        Purchases
        join provinceVienna on provinceVienna.ROWID = province),
maxTime as (
    select date(max(time), '+10 days') as maxTime from Dates
)
select id
from purchaseVienna where time = (select maxTime from maxTime);

-- 9.
with countriesRespectiveContinent as (
    select country, continent
    from Encompasses
    where percentage = 100
),
countriesProvince as (
    select continent, P.ROWID as province
    from countriesRespectiveContinent C
    join Province P on C.country = P.country
),
lastTenDays as (
    select qty, province, sum(cnt) as cnt
    from purchases_per_day
    where time > (select max(time) as time from Dates)
    group by province, qty
),
lastTenDaysFullCountries as (
    select continent, qty, cnt
    from
        lastTenDays L
        join countriesProvince C on L.province = C.province
) select continent, qty, sum(cnt) as cnt
from lastTenDaysFullCountries
group by continent, qty;

-- 10.
with lastTenDays as (
    select max(time) as time
    from Dates
),
lastTwentyDays as (
    select time as ten, date(time, '-10 days') as twenty
    from lastTenDays
),
itemsLastTenDays as (
    select province, cnt * qty as qty_last_ten_days
    from
        purchases_per_day P
        join lastTenDays L on P.time > L.time
/*     order by qty_last_ten_days desc*/
),
itemsTenPerProvince as (
    select province, sum(qty_last_ten_days) as qty_last_ten_days
    from
        itemsLastTenDays
    group by province
),
itemsTwentyToTen as (
    select province, cnt * qty as qty_twenty_to_ten_days
    from
        purchases_per_day P
        join lastTwentyDays L on P.time > L.twenty and P.time <= L.ten
/*     order by qty_twenty_to_ten_days desc*/
),
itemsTwentyPerProvince as (
    select province, sum(qty_twenty_to_ten_days) as qty_twenty_to_ten_days
    from
        itemsTwentyToTen
    group by province
),
tenMax as (
    select I10.province, qty_last_ten_days, qty_twenty_to_ten_days
    from
        itemsTenPerProvince I10
        join itemsTwentyPerProvince I20 on I10.province = I20.province
    order by (qty_last_ten_days - qty_twenty_to_ten_days) desc
    limit 10
) select P.name as province, C.name as country, qty_last_ten_days as qty_last10, qty_twenty_to_ten_days as qty_1020
from
    tenMax T
    join Province P on T.province = P.ROWID
    join Country C on P.country = C.code;
