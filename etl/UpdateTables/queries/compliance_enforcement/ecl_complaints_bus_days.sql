SELECT compl.complaintjobid,
       compl.complaintnumber,
       compl.address,
       compl.complaintcode,
       compl.complainttype,
       compl.complaintdate,
       trunc (sysdate - compl.complaintdate) cdsincecomplaint,
       (
           CASE
               WHEN trunc (sysdate - compl.complaintdate) <= 5
               THEN '0-5'
               WHEN trunc (sysdate - compl.complaintdate) BETWEEN 6 AND 20
               THEN '6-20'
               WHEN trunc (sysdate - compl.complaintdate) BETWEEN 21 AND 30
               THEN '21-30'
               ELSE 'More than 30'
           END
       ) cdsincecomplaintcategories,
       bds2.businessdayssince - bds1.businessdayssince bdsincecomplaint,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= 5
               THEN '0-5'
               WHEN bds2.businessdayssince - bds1.businessdayssince BETWEEN 6 AND 20
               THEN '6-20'
               WHEN bds2.businessdayssince - bds1.businessdayssince BETWEEN 21 AND 30
               THEN '21-30'
               ELSE 'More than 30'
           END
       ) bdsincecomplaintcategories,
       compl.complaintstatus,
       compl.reviewcomplaint_date,
       compl.reviewcomplaint_status,
       compl.reviewcomplaint_assignedto,
       compl.reviewcomplaint_outcome,
       compl.casenumber,
       compl.firstinv_date,
       compl.mostrecentinv_date,
       compl.mostrecentinv_dayofweek,
       compl.mostrecentinv_status,
       compl.mostrecentinv_assignedto,
       compl.mostrecentinv_outcome,
       compl.complaint_resolutiondate,
       compl.resolutionstatus,
       compl.inspectiondiscipline,
       compl.origintype,
       compl.district,
       compl.firstaction_date,
       (
           CASE
               WHEN compl.firstaction_date IS NULL
               THEN trunc (sysdate - compl.complaintdate)
               ELSE trunc (compl.firstaction_date) - compl.complaintdate
           END
       ) cdbeforefirstaction,
       (
           CASE
               WHEN compl.firstaction_date IS NULL
               THEN (
                   CASE
               WHEN trunc (sysdate - compl.complaintdate) <= 5
               THEN '0-5'
               WHEN trunc (sysdate - compl.complaintdate) BETWEEN 6 AND 20
               THEN '6-20'
               WHEN trunc (sysdate - compl.complaintdate) BETWEEN 21 AND 30
               THEN '21-30'
               ELSE 'More than 30'
                   END
               )
               ELSE (
                   CASE
                       WHEN trunc (compl.firstaction_date - compl.complaintdate) <= 5
                       THEN '0-5'
                       WHEN trunc (compl.firstaction_date - compl.complaintdate) BETWEEN 6 AND 20
                       THEN '6-20'
                       WHEN trunc (compl.firstaction_date - compl.complaintdate) BETWEEN 21 AND 30
                       THEN '21-30'
                       ELSE 'More than 30'
                   END
               )
           END
       ) cdbeforefirstactioncategories,
       (
           CASE
               WHEN compl.firstaction_date IS NULL
               THEN (
                   CASE
                       WHEN trunc (sysdate - compl.complaintdate) <= compl.sla
                       THEN 'Yes'
                       ELSE 'No'
                   END
               )
               ELSE
                   CASE
                       WHEN trunc (compl.firstaction_date - compl.complaintdate) <= compl.sla
                       THEN 'Yes'
                       ELSE 'No'
                   END
           END
       ) cdwithinsla,
       compl.sla,
       compl.lon,
       compl.lat
FROM ecl_complaints compl,
     business_days_since_2007 bds1,
     business_days_since_2007 bds2
WHERE to_date (to_char (compl.complaintdate, 'mm') || to_char (compl.complaintdate, 'dd') || to_char (compl.complaintdate, 'yyyy'
), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (sysdate, 'mm') || to_char (sysdate, 'dd') || to_char (sysdate, 'yyyy'), 'MMDDYYYY') = bds2.dateofyear
      (+)