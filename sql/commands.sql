CREATE EXTERNAL TABLE test
STORED AS CSV
WITH HEADER ROW
LOCATION 'data/test.csv';

SELECT * FROM test;

SELECT a, b, (a + b) FROM test;
