CREATE OR REPLACE VIEW flights.fview
-- CREATE MATERIALIZED VIEW flights.fview
-- PARTITION BY DATE_TRUNC(FL_DATE, MONTH)
AS
SELECT
  FlightDate AS FL_DATE,
  Reporting_Airline AS UNIQUE_CARRIER,
  OriginAirportSeqID AS ORIGIN_AIRPORT_SEQ_ID,
  Origin AS ORIGIN,
  DestAirportSeqID AS DEST_AIRPORT_SEQ_ID,
  Dest AS DEST,
  CRSDepTime AS CRS_DEP_TIME,
  DepTime AS DEP_TIME,
  CAST(DepDelay AS FLOAT64) AS DEP_DELAY,
  CAST(TaxiOut AS FLOAT64) AS TAXI_OUT,
  WheelsOff AS WHEELS_OFF,
  WheelsOn AS WHEELS_ON,
  CAST(TaxiIn AS FLOAT64) AS TAXI_IN,
  CRSArrTime AS CRS_ARR_TIME,
  ArrTime AS ARR_TIME,
  CAST(ArrDelay AS FLOAT64) AS ARR_DELAY,
  IF(Cancelled = '1.00', True, False) AS CANCELLED,
  IF(Diverted = '1.00', True, False) AS DIVERTED,
  DISTANCE
FROM flights.raw;

CREATE OR REPLACE VIEW
  flights.delayed_10 AS
SELECT
  * 
FROM
  flights.raw
WHERE
  CAST(DepDelay AS float64) >= 10;

CREATE OR REPLACE VIEW
  flights.delayed_15 AS
SELECT
  * 
FROM
  flights.raw
WHERE
  CAST(DepDelay AS float64) >= 15;

CREATE OR REPLACE VIEW
  flights.delayed_20 AS
SELECT
  * 
FROM
  flights.raw
WHERE
  CAST(DepDelay AS float64) >= 20;