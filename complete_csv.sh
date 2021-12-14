#!/bin/bash

#export YEAR=${YEAR:=2015}
SOURCE=https://transtats.bts.gov/PREZIP

OUTDIR=raw
mkdir -p $OUTDIR
cd $OUTDIR

PROJECT=$(gcloud config get-value project)
gsutil mb gs://${PROJECT}-ml

for YEAR in `seq 2019 2019`; do
for MONTH in `seq 1 3`; do

  FILE=On_Time_Reporting_Carrier_On_Time_Performance_1987_present_${YEAR}_${MONTH}.zip
  curl -k -o ${FILE}  ${SOURCE}/${FILE}
  unzip -o ${FILE}
  rm ${FILE}
  sed 1d 'On_Time_Reporting_Carrier_On_Time_Performance_(1987_present)_2019_'${MONTH}'.csv' > 'datzip_'${MONTH}'.csv'
  rm 'On_Time_Reporting_Carrier_On_Time_Performance_(1987_present)_2019_'${MONTH}'.csv'
  gsutil mv 'datzip_'${MONTH}'.csv' gs://${PROJECT}-ml/flights/raw/'all_flights-0000'${MONTH}

done
done

SCHEMA=Year:STRING,Quarter:STRING,Month:STRING,DayofMonth:STRING,DayOfWeek:STRING,FlightDate:DATE,Reporting_Airline:STRING,DOT_ID_Reporting_Airline:STRING,IATA_CODE_Reporting_Airline:STRING,Tail_Number:STRING,Flight_Number_Reporting_Airline:STRING,OriginAirportID:STRING,OriginAirportSeqID:STRING,OriginCityMarketID:STRING,Origin:STRING,OriginCityName:STRING,OriginState:STRING,OriginStateFips:STRING,OriginStateName:STRING,OriginWac:STRING,DestAirportID:STRING,DestAirportSeqID:STRING,DestCityMarketID:STRING,Dest:STRING,DestCityName:STRING,DestState:STRING,DestStateFips:STRING,DestStateName:STRING,DestWac:STRING,CRSDepTime:STRING,DepTime:STRING,DepDelay:STRING,DepDelayMinutes:STRING,DepDel15:STRING,DepartureDelayGroups:STRING,DepTimeBlk:STRING,TaxiOut:STRING,WheelsOff:STRING,WheelsOn:STRING,TaxiIn:STRING,CRSArrTime:STRING,ArrTime:STRING,ArrDelay:STRING,ArrDelayMinutes:STRING,ArrDel15:STRING,ArrivalDelayGroups:STRING,ArrTimeBlk:STRING,Cancelled:STRING,CancellationCode:STRING,Diverted:STRING,CRSElapsedTime:STRING,ActualElapsedTime:STRING,AirTime:STRING,Flights:STRING,Distance:STRING,DistanceGroup:STRING,CarrierDelay:STRING,WeatherDelay:STRING,NASDelay:STRING,SecurityDelay:STRING,LateAircraftDelay:STRING,FirstDepTime:STRING,TotalAddGTime:STRING,LongestAddGTime:STRING,DivAirportLandings:STRING,DivReachedDest:STRING,DivActualElapsedTime:STRING,DivArrDelay:STRING,DivDistance:STRING,Div1Airport:STRING,Div1AirportID:STRING,Div1AirportSeqID:STRING,Div1WheelsOn:STRING,Div1TotalGTime:STRING,Div1LongestGTime:STRING,Div1WheelsOff:STRING,Div1TailNum:STRING,Div2Airport:STRING,Div2AirportID:STRING,Div2AirportSeqID:STRING,Div2WheelsOn:STRING,Div2TotalGTime:STRING,Div2LongestGTime:STRING,Div2WheelsOff:STRING,Div2TailNum:STRING,Div3Airport:STRING,Div3AirportID:STRING,Div3AirportSeqID:STRING,Div3WheelsOn:STRING,Div3TotalGTime:STRING,Div3LongestGTime:STRING,Div3WheelsOff:STRING,Div3TailNum:STRING,Div4Airport:STRING,Div4AirportID:STRING,Div4AirportSeqID:STRING,Div4WheelsOn:STRING,Div4TotalGTime:STRING,Div4LongestGTime:STRING,Div4WheelsOff:STRING,Div4TailNum:STRING,Div5Airport:STRING,Div5AirportID:STRING,Div5AirportSeqID:STRING,Div5WheelsOn:STRING,Div5TotalGTime:STRING,Div5LongestGTime:STRING,Div5WheelsOff:STRING,Div5TailNum:STRING

# create dataset if not exists
BUCKET=${PROJECT}-ml
#bq --project_id $PROJECT rm -f ${PROJECT}:flights.raw
#bq --project_id $PROJECT show dsongcp || bq mk dsongcp
bq mk flights
bq mk flights.raw

for MONTH in `seq 1 3`; do

CSVFILE=gs://${BUCKET}/flights/tzcoss/xll_flights-0000${MONTH}
bq load \
    --source_format=CSV \
    --ignore_unknown_values \
    --skip_leading_rows=1 \
    ${PROJECT}:flights.raw \
    gs://${BUCKET}/flights/raw/all_flights-0000${MONTH} \
    $SCHEMA

done

cd ..
PROJECT=$(gcloud config get-value project)
cat contingency4.sql \
   | bq --project_id $PROJECT query --nouse_legacy_sql

cat create_views.sql | bq --project_id $PROJECT query --nouse_legacy_sql
