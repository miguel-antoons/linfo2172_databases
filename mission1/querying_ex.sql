1.
select name from Mountain;

2.
select country from CountryCovid
where total_cases > 10000
and month = 3
and year = 2021;

3.
select Province.name, Country.name from Province
join Country on Country.code = Province.country
join Encompasses on Encompasses.country = Country.code
where Encompasses.continent = "Europe"
and Province.area < 200;

4.
select Country.name, Country.population, CountryCovid.total_deaths from CountryCovid
join Country on Country.code = CountryCovid.country
join Encompasses on Encompasses.country = Country.code
where CountryCovid.month = 12
and CountryCovid.year = 2022
and CountryCovid.total_deaths > 10000
and Encompasses.continent = "Europe";

5.
select Country.name, Independence.Independence from Country
join Independence on Independence.country = Country.code;

6.
select Country.code, Country.name from Country
where (
	select count(country1) from Borders
	where (country1 = "TJ" and country2 = Country.code)
	or (country1 = Country.code and country2 = "TJ")
) >= 1
and (
	select count(country1) from Borders
	where (country1 = "IND" and country2 = Country.code)
	or (country1 = Country.code and country2 = "IND")
) >= 1;

7.
select distinct Country.capital from Country
join GeoMountain on Country.code = GeoMountain.country
join Mountain on GeoMountain.mountain = Mountain.name
where Mountain.mountains = "Alps"
and Mountain.height > 4000;

8.
select Country.code, Country.name from Country
where (
	select count(Language.name) from Language
	where country = Country.code
) = 0;

9.
select distinct Mountain.mountains from Mountain
where (
    select count(distinct GeoMountain.country) from GeoMountain
    where GeoMountain.mountain = Mountain.name
) >= 2;

10.
select distinct Country.capital from CountryCovid
join Country on Country.code = CountryCovid.country
join Province on Province.capital = Country.capital and Province.country = Country.code
where CountryCovid.total_deaths > 10000;

11.
select C1.name from Country as C1
where (
	select count(country1) from Borders
	where (country1 = "USA" and country2 = C1.code)
	or (country1 = C1.code and country2 = "USA")
) >= 1
or C1.code in (
	select C2.code from Country as C2
	where (
		select count(country1) from Borders
		where (country1 in (
			select C3.code from Country as C3
			where (
				select count(country1) from Borders
				where (country1 = "USA" and country2 = C3.code)
				or (country1 = C3.code and country2 = "USA")
			) >= 1
		) and country2 = C2.code)
		or (country1 = C2.code and country2 = (
			select C4.code from Country as C4
			where (
				select count(country1) from Borders
				where (country1 = "USA" and country2 = C4.code)
				or (country1 = C4.code and country2 = "USA")
			) >= 1
		))
	)
)
and c1.code != "USA";

12.
select count(distinct country) as cnt from CountryCovid;

13.
select C1.code as country1, neighbours.country2 as country2 from Country as C1
left join (
    select C2.name, Borders.country1, Borders.country2 from Country as C2
    join Borders on Borders.country2 = C2.code
) as neighbours on C1.code = neighbours.country1
where C1.code not in (
    select CountryCovid.country from CountryCovid
    where CountryCovid.year < 2022
    group by CountryCovid.country
    having sum(CountryCovid.total_cases) = 0
);

select Borders.country1, Borders.country2 from Borders
where Borders.country1 not in (
    select CountryCovid.country from CountryCovid
    where CountryCovid.year < 2022
    group by CountryCovid.country
    having sum(CountryCovid.total_cases) = 0
);

14.
select L1.country, L1.name from Language as L1
where (
    select max(L2.percentage) from Language as L2
    where L2.country =L1.country
) = L1.percentage;
