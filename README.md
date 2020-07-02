# PostgreSQL-DataSketches
PostgreSQL-DataSketches brings [DataSketches functions](https://datasketches.apache.org/) to PostgreSQL via [PostgreSQL Adaptor for C++ DataSketches](https://github.com/apache/incubator-datasketches-postgresql).

## Run in [Docker](https://hub.docker.com/r/study/postgresql-datasketches)
```bash
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d study/postgresql-datasketches
```



## Test DataSketches functions in Docker

### Example
```bash
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d study/postgresql-datasketches

docker exec -it some-postgres psql -U postgres

postgres=# SELECT cpc_sketch_get_estimate(cpc_sketch_union(respondents_sketch)) AS num_respondents, flavor
FROM (
  SELECT
    cpc_sketch_build(respondent) AS respondents_sketch,
    flavor,
    country
  FROM (
    SELECT * FROM (
      VALUES (1, 'Vanilla', 'CH'),
             (1, 'Chocolate', 'CH'),
             (2, 'Chocolate', 'US'),
             (2, 'Strawberry', 'US')) AS t(respondent, flavor, country)) as foo
  GROUP BY flavor, country) as bar
GROUP BY flavor;
```


### Result

```
 num_respondents |   flavor   
-----------------+------------
               1 | Strawberry
               1 | Vanilla
2.00016277723359 | Chocolate
(3 rows)
```
