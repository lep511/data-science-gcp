WITH subq AS (    
    SELECT 
        CAST(ArrDelay AS float64) AS arr_delay,
        CAST(DepDelay AS float64) AS dep_delay  
    FROM flights.raw
),
contingency_table AS (
    SELECT 
        THRESH,
        COUNTIF(dep_delay < THRESH AND arr_delay < 15) AS true_negatives,
        COUNTIF(dep_delay < THRESH AND arr_delay >= 15) AS false_negatives,
        COUNTIF(dep_delay >= THRESH AND arr_delay < 15) AS false_positives,
        COUNTIF(dep_delay >= THRESH AND arr_delay >= 15) AS true_positives,
        COUNT(*) AS total
    FROM subq, UNNEST([5, 10, 11, 12, 13, 15, 20]) AS THRESH
    WHERE arr_delay IS NOT NULL AND dep_delay IS NOT NULL
    GROUP BY THRESH
)

SELECT
   ROUND((true_positives + true_negatives)/total, 2) AS accuracy,
   ROUND(false_positives/(true_positives+false_positives), 2) AS fpr,
   ROUND(false_negatives/(false_negatives+true_negatives), 2) AS fnr,
   *
FROM contingency_table;