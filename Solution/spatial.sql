#Postgres-PostGIS

#Creating a new table with name and gps coordinate
CREATE TABLE MyNeighborhood (name VARCHAR(1000), gps GEOMETRY);

#Inserting 9 points in the Map
INSERT INTO MyNeighborhood VALUES
('23rd/Vermont',ST_GeomFromText('POINT(-118.291565 34.035194)')),
('Expo/Vermont',ST_GeomFromText('POINT(-118.291507 34.018334)')),
('Expo/USC',ST_GeomFromText('POINT(-118.285882 34.018196)')),
('Expo/Flower',ST_GeomFromText('POINT(-118.280628 34.018426)')),
('Jefferson/Flower',ST_GeomFromText('POINT(-118.278325 34.021933)')),
('23rd/Flower',ST_GeomFromText('POINT(-118.273055 34.030199)')),
('23rd/Hoover',ST_GeomFromText('POINT(-118.28402 34.035209)')),
('Ralph''s',ST_GeomFromText('POINT(-118.291022 34.03184)')),
('Home',ST_GeomFromText('POINT(-118.280215 34.026354)'));

#Calculating Convex Hull
CREATE TABLE ConvexHull AS (SELECT ST_CONVEXHULL(ST_MULTI(ST_COLLECT(gps))) Hull from MyNeighborhood);
SELECT ST_ASTEXT(Hull) Hull FROM ConvexHull;
#                                                                                        hull                                                                                         
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# POLYGON((-118.285882 34.018196,-118.291507 34.018334,-118.291565 34.035194,-118.28402 34.035209,-118.273055 34.030199,-118.278325 34.021933,-118.280628 34.018426,-118.285882 34.018196))


#Finds 3 closest point
SELECT nn.name, ST_ASTEXT(local.gps) as Home, ST_ASTEXT(nn.gps) as Neighbor 
FROM MyNeighborhood local, MyNeighborhood nn 
WHERE local.name='Home' and nn.name <> 'Home' 
ORDER BY ST_Distance(local.gps, nn.gps) ASC LIMIT 3;

#       name       |             home             |           neighbor           
#------------------+------------------------------+------------------------------
# Jefferson/Flower | POINT(-118.280215 34.026354) | POINT(-118.278325 34.021933)
# Expo/Flower      | POINT(-118.280215 34.026354) | POINT(-118.280628 34.018426)
# 23rd/Flower      | POINT(-118.280215 34.026354) | POINT(-118.273055 34.030199)