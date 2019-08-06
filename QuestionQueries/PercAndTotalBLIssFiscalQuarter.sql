WITH Q AS(    
    SELECT SUB.FISCAL_QUARTER, SUB.YR, COUNT(*) AS QUARTERLY_COUNT
    FROM 
        (SELECT mod(to_char(issuedate,'Q') + 1, 4)+1 FISCAL_QUARTER, --TO_CHAR("GIS_LNI"."LICENSES_ISSUED_BL"."ISSUEDATE", 'Q') AS quarter
        CASE 
            WHEN EXTRACT(MONTH FROM issuedate) >= 7 THEN ((EXTRACT(YEAR FROM issuedate)) + 1)
            WHEN EXTRACT(MONTH FROM issuedate) <= 6 THEN (EXTRACT(YEAR FROM issuedate))
           -- WHEN (EXTRACT(YEAR FROM issuedate) = 2020) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 3 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 4) THEN 2020
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2019) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 1 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 2) THEN 2018
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2019) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 3 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 4) THEN 2019
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2018) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 1 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 2) THEN 2017
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2018) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 3 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 4) THEN 2018
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2017) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 1 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 2) THEN 2016
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2017) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 3 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 4) THEN 2017
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2016) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 1 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 2) THEN 2015
            --WHEN (EXTRACT(YEAR FROM issuedate) = 2016) AND ((mod(to_char(issuedate,'Q') + 1, 4)+1) = 3 OR (mod(to_char(issuedate,'Q') + 1, 4)+1) = 4) THEN 2016
        END YR --EXTRACT(YEAR FROM "GIS_LNI"."LICENSES_ISSUED_BL"."ISSUEDATE") AS year
        FROM licenses_issued_bl) SUB
    GROUP BY SUB.YR, sub.fiscal_quarter)
SELECT
    Q.YR,
    Q.FISCAL_QUARTER,
    Q.QUARTERLY_COUNT,
    A.ANNUAL_COUNT,
    ROUND(Q.QUARTERLY_COUNT / A.ANNUAL_COUNT * 100, 1) AS ANNUAL_PERCENTAGE
FROM Q
INNER JOIN (
    SELECT SSUB.YR, COUNT(*) AS ANNUAL_COUNT
    FROM
        (SELECT
            CASE 
                WHEN EXTRACT(MONTH FROM issuedate) >= 7 THEN ((EXTRACT(YEAR FROM issuedate)) + 1)
                WHEN EXTRACT(MONTH FROM issuedate) <= 6 THEN (EXTRACT(YEAR FROM issuedate))
            END YR
            FROM licenses_issued_bl) SSUB
    GROUP BY SSUB.YR
) A ON Q.YR = A.YR
ORDER BY
    Q.YR ASC, 
    q.fiscal_quarter ASC