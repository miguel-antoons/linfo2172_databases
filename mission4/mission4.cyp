//! for subimission : do not forget to set string number as real numbers
// 1. List the full names of countries that border Greece and are not 100% located in Europe. Make
// sure to include every country in your output only once.
match (c:Country)-[:Borders]->(g:Country {name: "Greece"})
match (c)<-[enc:Encompasses]-(con:Continent {name: "Europe"})
where enc.percentage <> "100.0"
return distinct c.name;


// 2. List the pairs of countries that neighbor China, and that are also neighbors of each other.
// Provide the full names of both countries; only list the pairs in which the rst name of the pair
// is strictly lower than the second name in the pair.
match (c:Country)-[:Borders]->(ch:Country {name: "China"})
match (c2:Country)-[:Borders]->(ch:Country {name: "China"})
match (c)-[:Borders]->(c2)
where c2.name < c.name
return distinct c2.name, c.name;


// 3. Provide the full names of all countries that are 100% located in Europe, but that border a
// country not located, or not entirely located, in Europe.
match (c:Country)<-[enc:Encompasses]-(:Continent {name: "Europe"})
where enc.percentage = "100.0"
with collect(distinct c.name) as europe
match (c2:Country)
where not c2.name in europe
match (c:Country)<-[:Borders]-(c2)
where c.name in europe
return distinct c.name;


// 4. Provide the full names of all countries in Asia that can be reached in at most two steps from
// Turkey, excluding Turkey itself. Make sure to include every country in the output only once.
match (c:Country {name: "Turkey"})-[:Borders*1..2]->(c2:Country)
match (c2)<-[enc:Encompasses]-(:Continent {name: "Asia"})
where c2.name <> "Turkey"
return distinct c2.name;


// 5. List the number of neighboring countries for every country located in Europe (i.e., this is the
// degree of every country in Europe, when only considering the Borders relation). Provide for
// each country the full name, and its degree. Sort the output in decreasing order of degree.
match (c:Country)-[:Borders]->(c2:Country)<-[enc:Encompasses]-(:Continent {name: "Europe"})
with count(distinct c.name) as degree, c2.name as name
return name, degree
order by degree desc;


// 6. Find the country with the largest number of neighbors; if there are multiple such countries, it
// is allowed to break ties arbitrarily; provide the full name and the number of neighbors.
match (c:Country)-[:Borders]->(c2:Country)
with count(distinct c.name) as degree, c2.name as name
return name, degree
order by degree desc
limit 1;


// 7. Determine the shortest path from Belgium to China; provide the complete path, that is, all
// nodes and edges on this path, starting from Belgium and ending in China.
match (c:Country {name: "Belgium"}), (c2:Country {name: "China"})
match p = shortestPath((c)-[*]->(c2))
return distinct p;


// 8. Find the country which has the longest shortest path to Belgium; provide the full name of this
// country.
match (c:Country)
where c.name <> "Belgium"
match (c2:Country {name: "Belgium"})
match p = shortestPath((c)-[*]->(c2))
with distinct c.name as name, length(p) as length
return name
order by length desc
limit 1;


// 9. Luxembourg is in a specic topographic situation: it has exactly three neighboring countries
// (Belgium, Germany, and France), each of which are pairwise neighbors of each other as well.
// As a result, Luxembourg is surrounded by exactly three countries. List the full names of all
// countries that are in a similar situation as Luxembourg.
match (c:Country)-[:Borders]->(c2:Country)
with count(distinct c2.name) as degree, c
match (c)-[:Borders]->(c2:Country)
where degree = 3
with distinct c, collect(distinct c2.name) as neighbors
match (c)-[:Borders]-(c2:Country {name: neighbors[0]})-[:Borders]-(c3:Country {name: neighbors[1]})-[:Borders]-(c4:Country {name: neighbors[2]})-[:Borders]-(c2:Country {name: neighbors[0]})
return distinct c.name;


// 10. List all countries in Europe for which there is no path of length in between 1 and 3 to a country
// (entirely or partially) located in Asia.
match (cAsia:Country)<-[:Encompasses]-(:Continent {name: "Asia"})
match (cEurope:Country)<-[:Encompasses]-(:Continent {name: "Europe"})
match (cAsia)-[:Borders]->(cEurope)
with distinct cEurope
match (cEurope)-[:Borders]->(c1:Country)
with distinct c1
match (c1)-[:Borders]->(c2:Country)
with distinct c2, c1
with collect(distinct c1.name) as c1, collect(distinct c2.name) as c2
match (cEurope:Country)<-[:Encompasses]-(:Continent {name: "Europe"})
where not cEurope.name in c1 and not cEurope.name in c2
return distinct cEurope.name;
