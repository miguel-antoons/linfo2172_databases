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
match (c:Country)-[enc:Encompasses]->(:Continent {name: "Europe"})
where enc.percentage = "100.0"
match (c)-[:Borders]->(c2:Country)
where not c2 in c
return distinct c.name;