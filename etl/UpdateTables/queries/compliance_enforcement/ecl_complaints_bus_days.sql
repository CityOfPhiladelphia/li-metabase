SELECT compl.complaintjobid,
       compl.complaintnumber,
       compl.address,
       compl.complaintcode,
       compl.complainttype,
       compl.complaintdate,
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
       compl.sla,
       compl.lon,
       compl.lat,
       bds2.businessdayssince - bds1.businessdayssince bdsincecomplaint,
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
       ) bdsincecomplaintcategories
FROM ecl_complaints compl,
     business_days_since_2007 bds1,
     business_days_since_2007 bds2
WHERE to_date (to_char (compl.complaintdate, 'mm') || to_char (compl.complaintdate, 'dd') || to_char (compl.complaintdate, 'yyyy'
), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (sysdate, 'mm') || to_char (sysdate, 'dd') || to_char (sysdate, 'yyyy'), 'MMDDYYYY') = bds2.dateofyear
      (+)
