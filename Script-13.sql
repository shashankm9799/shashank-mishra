--state  table create 
create table state as (
select gid stateid, name_0  country ,name_1 state,type_1  type,geom  from ind_adm1 ia )



--district table create
create table district as (
select id_2  distictid , name_1 state,name_2 district,type_2  type ,geom  from ind_adm2 ia )

--taluka
create table taluk as (
select id_3  talukid ,name_0  country , name_1 state , name_2 taluk , type_3  type , geom  from ind_adm3 ia )

--water areas
create table waterarea as (
select gid ,f_code_des  , hyc_descri  ,"name"  geom  from ind_water_areas_dcw iwad )

--water line
create table waterline as (
select  gid , f_code_des , hyc_descri  ,nam as name ,geom  from ind_water_lines_dcw iwld )

--road
create table road as (
select gid , med_descri  , rtt_descri type , geom  from ind_roads ir )

--rail
create table rail as (
select  f_code_des ,exs_descri use , fco_descri type,geom  from ind_rails ir )

--drop the existed table
drop table  ind_roads ,ind_adm1  ,ind_adm2  , ind_adm3  , ind_water_areas_dcw  , ind_water_lines_dcw 


select * from ne_10m_admin_0_countries nmac 

###############################################################


create table sdtdata as (
SELECT d.state , d.district , t.taluk ,d.geom d_geom,t.geom t_geom  from taluk t
left join district d on t.state= d.state)

--. Calculate Distance between points

select state , district , ST_DistanceSphere(d_geom , t_geom)  from sdtdate 

SELECT state, district,ST_DistanceSphere(d_geom, t_geom) as distance_sphere FROM sdtdate 

SELECT state, district,ST_DistanceSpheroid(d_geom, t_geom, 'SPHEROID["WGS 84",6378137,298.257223563]') as distance_spheroid FROM sdtdate limit 20;

SELECT state, district,ST_Distance(d_geom::geography, t_geom::geography)/1000 as distance_geography_km FROM sdtdate;

SELECT state, district,ST_Distance(d_geom::geography, t_geom::geography)/1609.34 as distance_geography_miles FROM sdtdate;

SELECT state, district, ST_Distance(d_geom, t_geom) as distance_cartesian FROM sdtdate;

SELECT state, district,
  ST_DistanceSphere(d_geom, t_geom) as distance_sphere,
  ST_DistanceSpheroid(d_geom, t_geom, 'SPHEROID["WGS 84",6378137,298.257223563]') as distance_spheroid,
  ST_Distance(d_geom::geography, t_geom::geography)/1000 as distance_geography_km,
  ST_Distance(d_geom::geography, t_geom::geography)/1609.34 as distance_geography_miles,
  ST_Distance(d_geom, t_geom) as distance_cartesian
FROM sdtdate;

#################################################

-- Calculate Areas of Interest

SELECT state, ST_Area(geom) AS area_in_sq_meters FROM state;

SELECT state, ST_Area(geom::geography)/10000 AS area_in_hectares FROM state;

SELECT state, ST_Area(geom::geography)/1000000 AS area_in_sq_km FROM state;

SELECT state, ST_Area(geom::geography)*0.000247105 AS area_in_acres FROM state;

SELECT state, ST_Area(geom::geography)*0.000000386102 AS area_in_sq_miles FROM state;

SELECT state, ST_Area(geom::geography)*10.76391041671 AS area_in_sq_feet FROM state;


SELECT 
  state, 
  ST_Area(geom) AS area_in_sq_meters,
  ST_Area(geom::geography)/10000 AS area_in_hectares,
  ST_Area(geom::geography)/1000000 AS area_in_sq_km,
  ST_Area(geom::geography)*0.000247105 AS area_in_acres,
  ST_Area(geom::geography)*0.000000386102 AS area_in_sq_miles,
  ST_Area(geom::geography)*10.76391041671 AS area_in_sq_feet
FROM state;


EXPLAIN SELECT state, ST_Area(geom::geography)/1000000 AS area_in_sq_km FROM state;

EXPLAIN ANALYZE SELECT state, ST_Area(geom::geography)/1000000 AS area_in_sq_km FROM state;


EXPLAIN SELECT d.state, d.district, MIN(ST_DistanceSphere(d.geom, t.geom)) as min_distance_in_meters,
MAX(ST_DistanceSphere(d.geom, t.geom)) as max_distance_in_meters
FROM taluk t
LEFT JOIN district d ON t.state = d.state
GROUP BY d.state, d.district;

--EXPLAIN analyze SELECT d.state, d.district, MIN(ST_DistanceSphere(d.geom, t.geom)) as min_distance_in_meters,
--MAX(ST_DistanceSphere(d.geom, t.geom)) as max_distance_in_meters
--FROM taluk t
--LEFT JOIN district d ON t.state = d.state
--GROUP BY d.state, d.district;


explain sELECT 
  state, 
  ST_Area(geom) AS area_in_sq_meters,
  ST_Area(geom::geography)/10000 AS area_in_hectares,
  ST_Area(geom::geography)/1000000 AS area_in_sq_km,
  ST_Area(geom::geography)*0.000247105 AS area_in_acres,
  ST_Area(geom::geography)*0.000000386102 AS area_in_sq_miles,
  ST_Area(geom::geography)*10.76391041671 AS area_in_sq_feet
FROM state;




SELECT * FROM state ORDER BY order_date DESC;

SELECT * FROM state
LIMIT 10;


SELECT * FROM district
ORDER BY distictid DESC
OFFSET 10
LIMIT 10;


SELECT * FROM district
ORDER BY distictid DESC
OFFSET 10
LIMIT 10;

SELECT state, SUM(total_sales) as total_sales
FROM district
GROUP BY state;


SELECT state, sum(distictid) as total_sales
FROM district
GROUP BY state
HAVING sum(distictid) > 30;

SELECT talukid,taluk, ST_Area(geom) AS area_in_sq_meters
FROM taluk
ORDER BY area_in_sq_meters DESC;


SELECT talukid,taluk, ST_Area(geom) AS area_in_sq_meters
FROM taluk
ORDER BY area_in_sq_meters DESC;

SELECT talukid,taluk, ST_Area(geom) AS area_in_sq_meters
FROM taluk
ORDER BY area_in_sq_meters DESC
LIMIT 10;


SELECT talukid,taluk, ROUND(ST_Area(geom), 2) AS area_in_sq_meters
FROM taluk
ORDER BY area_in_sq_meters DESC
LIMIT 10;


SELECT talukid, ST_Area(geom) AS area_in_sq_meters
FROM taluk
WHERE ST_Area(geom) > 1;


SELECT talukid, ST_Area(geom)/1000000 AS area_in_sq_km
FROM  taluk


CREATE INDEX taluk_name_idx ON taluk(taluk);


EXPLAIN ANALYZE SELECT taluk, geom FROM taluk WHERE state = 'Karnataka';

CREATE INDEX taluk_state_hash_idx ON taluk USING HASH(state);

EXPLAIN SELECT * FROM taluk WHERE state = 'Karnataka';


CREATE INDEX taluk_geom_gist_idx ON taluk USING GIST(geom);

-- EXPLAIN ANALYZE SELECT taluk FROM taluk WHERE ST_Contains(geom, ST_MakePoint(77.5946, 12.9719));

SELECT *
FROM taluk
WHERE ST_Contains(ST_Transform(geom, 4326), ST_SetSRID(ST_MakePoint(77.5946, 12.9716), 4326));

Explain SELECT *
FROM taluk
WHERE ST_Contains(ST_Transform(geom, 4326), ST_SetSRID(ST_MakePoint(77.5946, 12.9716), 4326));


CREATE EXTENSION pg_trgm; -- This is required to use the trigram operator class
CREATE INDEX taluk_name_geom_gin_idx ON taluk USING GIN(taluk gin_trgm_ops, geom);

EXPLAIN ANALYZE SELECT taluk, geom FROM taluk WHERE state = 'Karnataka';


CREATE INDEX taluk_geom_spgist_idx ON taluk USING SPGIST(geom);

SELECT taluk, ST_Area(geom) as area
FROM taluk
WHERE ST_Within(ST_Transform(geom, 4326), ST_Buffer(ST_Transform(ST_SetSRID(ST_Point(77.5946, 12.9716), 4326), 26910), 5000));

SELECT * FROM taluk WHERE ST_Contains(ST_Transform('POINT(77.5946 12.9716)', 4326), ST_Transform(geom, 4326));

SET search_path = public;

SELECT * FROM taluk WHERE ST_Contains(public.ST_Transform('POINT(77.1234 12.3456)', 4326), geom);

select * from taluk WHERE state = 'Karnataka';

explain select * from taluk WHERE state = 'Karnataka';


CREATE INDEX taluk_taluk_idx ON taluk(taluk);
CREATE INDEX state_state_idx ON state(state);
CREATE INDEX taluk_geom_gist_idx ON taluk USING GIST(geom);
CREATE INDEX state_geom_gist_idx ON state USING GIST(geom);



EXPLAIN SELECT taluk.taluk, state.state, ST_DistanceSphere(taluk.geom, state.geom) AS distance
FROM taluk, state
WHERE taluk.talukid = 1 AND state.stateid = 1;


SELECT *
FROM state
WHERE stateid IN (SELECT stateid FROM taluk WHERE  talukid = 1 );


SELECT taluk.taluk, state.state, ST_DistanceSphere(taluk.geom, state.geom) AS distance
FROM taluk, state
WHERE taluk.talukid = 1 AND state.stateid = 1;


CREATE INDEX taluk_taluk_idx ON taluk(taluk);
CREATE INDEX state_state_idx ON state(state);
CREATE INDEX taluk_geom_gist_idx ON taluk USING GIST(geom);
CREATE INDEX state_geom_gist_idx ON state USING GIST(geom);


SELECT taluk.taluk, state.state, ST_DistanceSphere(taluk.geom, state.geom) AS distance
FROM taluk, state
WHERE taluk.talukid = 1 AND state.stateid = 1;

SELECT s.state, d.district, MIN(ST_DistanceSphere(s.geom, t.geom)) AS min_distance, MAX(ST_DistanceSphere(s.geom, t.geom)) AS max_distance
FROM state s, taluk t, district d
WHERE ST_Within(t.geom, d.geom) AND ST_Within(s.geom, d.geom)
GROUP BY s.state, d.district;

SET max_parallel_workers_per_gather = 2;
SELECT *
FROM taluk
WHERE state = 'Karnataka';

SELECT *
FROM taluk
WHERE talukid IN (SELECT talukid FROM some_other_table WHERE condition);

CREATE TEMPORARY TABLE temp_table AS (
  SELECT talukid, taluk, geom FROM taluk WHERE stateid = 1
);

SELECT * FROM temp_table ;

EXPLAIN ANALYZE SELECT * FROM taluk WHERE stateid = 1;

ALTER TABLE taluk ALTER COLUMN geom TYPE geometry(MultiPolygon, 4326) USING ST_SetSRID(geom, 4326);


SELECT t.talukid, t.taluk, d.distictid, d.district
FROM taluk t
INNER JOIN district d ON ST_Intersects(t.geom, d.geom);


select s.state, s.type, d.district, d.type, t.taluk, t.type, iw.*
from state s
left join district d on ST_Intersects(s.geom, ST_SetSRID(d.geom, 4326))
left join taluk t on ST_Intersects(ST_SetSRID(t.geom, 4326), ST_SetSRID(d.geom, 4326))
left join ind_water_areas_dcw iw on ST_Intersects(ST_SetSRID(iw.geom, 4326), ST_SetSRID(d.geom, 4326))































