SELECT oi.businessaddress,
       oi.licensenumber,
       oi.licensetype,
       oi.jobnumber,
       oi.inspectionnumber,
       oi.inspectionagainst,
       oi.inspectiontype,
       oi.inspectionobjectid,
       oi.inspectioncreateddate,
       oi.scheduledinspectiondate,
       bds2.businessdayssince - bds1.businessdayssince busdaysoverdue,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= 10
               THEN '0-10'
               WHEN bds2.businessdayssince - bds1.businessdayssince BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds2.businessdayssince - bds1.businessdayssince BETWEEN 21 AND 100
               THEN '21-100'
               ELSE 'More than 100'
           END
       ) busdaysoverduecategories,
       oi.inspector,
       oi.link
FROM overdue_inspections_bl oi,
     business_days_since_2016 bds1,
     business_days_since_2016 bds2
WHERE to_date (to_char (oi.scheduledinspectiondate, 'mm') || to_char (oi.scheduledinspectiondate, 'dd') || to_char (oi.scheduledinspectiondate
, 'yyyy'), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (sysdate, 'mm') || to_char (sysdate, 'dd') || to_char (sysdate, 'yyyy'), 'MMDDYYYY') = bds2.dateofyear
      (+)