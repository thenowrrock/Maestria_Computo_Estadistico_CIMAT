-- Maestría en Computo Estadistico
-- CIMAT, Unidad Monterrey.
-- Programacion y Analisis de Algoritmos.
-- Enrique Santibañez Cortes
-- Tarea 4: Lenguaje de Consulta de Base de Datos.
-- 17-Nov-2020.
-- Repositorio de Github: https://github.com/Enriquesec/Programcion_y_analisis_de_algoritmos/tree/master/Tareas/Tarea_4/

-- ### Consultas y campos calculados
-- 1. 
SELECT name, composer, unitprice 
FROM tracks;

-- 2.
SELECT name, composer, unitprice 
FROM tracks 
WHERE milliseconds>200000;

-- 3.
SELECT name, unitprice,  bytes/1000000 AS megabytes 
FROM tracks 
WHERE milliseconds>300000;

-- 4.
SELECT name,  unitprice 
FROM tracks 
WHERE  bytes=(
	SELECT MAX(bytes)
	FROM tracks
	);

-- 5.
SELECT name, composer, (1.0*bytes/1048576)/(1.0*milliseconds/1000) AS megabytes_per_seconds
FROM tracks
ORDER BY  megabytes_per_seconds DESC;

-- ### Agregación y verificación
-- 1. 
SELECT albumid, SUM(milliseconds) as total_milliseconds
FROM tracks
GROUP BY albumid;

-- 2.
SELECT genreid, MAX(milliseconds/1000) AS max_seconds
FROM tracks
GROUP BY (genreid);

-- 3.
SELECT customerid, SUM(total) as sum_total
FROM invoices
GROUP BY customerid
ORDER BY sum_total DESC;

-- 4.
SELECT invoiceid, COUNT(invoiceid) as count_register
FROM invoice_items
GROUP BY invoiceid
ORDER BY count_register
LIMIT 10;

-- 5. 
SELECT artistid, count(artistid) as count_register
FROM albums
GROUP BY artistid
ORDER BY count_register DESC
LIMIT 10;
-- ¿Qué significa dentro de la tabla?
-- Respuesta: El significado de la consulta anterior nos da una lista de los 10 artistas (su ID) que tienen
-- más canciones en la base de datos de chinook.db, por ejemplo: el artista con artistID igual a 90 tienen
-- 21 canciones distintas en la base de datos chinook.db. 

-- ## Unión de tablas
-- 1.
SELECT albumid, title, al.artistid AS artistid, name  FROM albums al
INNER JOIN (SELECT name, artistid FROM artists) ar 
ON al.artistid= ar.artistid;

-- 2.
SELECT inv.customerid AS customerid, invoiceid, invoicedate, total, firstname, lastname, email
FROM invoices inv
INNER JOIN (SELECT firstname, lastname, email, customerid FROM customers) cus
ON inv.customerid = cus.customerid;

-- 3.
SELECT t.name AS TrackName, al.title AS AlbumName,  gen.name AS GeneroName, mt.name AS MediaTypeName
FROM tracks t
INNER JOIN genres gen ON t.genreid=gen.genreid
INNER JOIN albums al ON t.albumid=al.albumid
INNER JOIN media_types mt ON t.mediatypeid = mt.mediatypeid;

-- 4.
SELECT firstname, lastname, email, SUM(inv_item.unitprice) as total_by_customer, COUNT(inv_item.trackid) AS count_track FROM invoices inv
INNER JOIN invoice_items inv_item ON inv.invoiceid=inv_item.invoiceid
INNER JOIN (SELECT firstname, lastname, customerid, email FROM customers) cus ON inv.customerid=cus.customerid
GROUP BY cus.customerid
ORDER BY count_track;

-- 5.
SELECT firstname, lastname, email FROM invoice_items inv_items
INNER JOIN invoices inv ON inv_items.invoiceid = inv.invoiceid
INNER JOIN (SELECT genreid, trackid FROM tracks WHERE genreid=21) t  ON inv_items.trackid = t.trackid
INNER JOIN (SELECT firstname, lastname, customerid, email FROM customers) cus 
ON inv.customerid=cus.customerid
GROUP BY cus.customerid;