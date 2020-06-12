SELECT complaintjobid,
       complaintnumber,
       address,
       complaintcode,
       complaintcodename,
       complaintdate,
       complaintstatus,
       reviewcomplaint_date,
       reviewcomplaint_status,
       reviewcomplaint_assignedto,
       reviewcomplaint_outcome,
       casenumber,
       firstinv_date,
       mostrecentinv_date,
       mostrecentinv_dayofweek,
       mostrecentinv_status,
       mostrecentinv_assignedto,
       mostrecentinv_outcome,
       complaint_resolutiondate,
       resolutionstatus,
       inspectiondiscipline,
       origintype,
       district,
       sla,
       lon,
       lat,
       bds2.businessdayssince - bds1.businessdayssince bdoutstanding,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= compl.sla
               THEN 'Yes'
               ELSE 'No'
           END
       ) withinsla,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= compl.sla
               THEN NULL
               ELSE bds2.businessdayssince - bds1.businessdayssince - compl.sla
           END
       ) bdoverdue
FROM ecl_complaints compl,
     business_days_since_2016 bds1,
     business_days_since_2016 bds2
WHERE to_date (to_char (compl.complaintdate, 'mm') || to_char (compl.complaintdate, 'dd') || to_char (compl.complaintdate, 'yyyy'
), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (compl.firstinv_date, 'mm') || to_char (compl.firstinv_date, 'dd') || to_char (compl.firstinv_date, 'yyyy'
      ), 'MMDDYYYY') = bds2.dateofyear (+)
      AND compl.firstinv_date IS NOT NULL
UNION
SELECT complaintjobid,
       complaintnumber,
       address,
       complaintcode,
       complaintcodename,
       complaintdate,
       complaintstatus,
       reviewcomplaint_date,
       reviewcomplaint_status,
       reviewcomplaint_assignedto,
       reviewcomplaint_outcome,
       casenumber,
       firstinv_date,
       mostrecentinv_date,
       mostrecentinv_dayofweek,
       mostrecentinv_status,
       mostrecentinv_assignedto,
       mostrecentinv_outcome,
       complaint_resolutiondate,
       resolutionstatus,
       inspectiondiscipline,
       origintype,
       district,
       sla,
       lon,
       lat,
       bds2.businessdayssince - bds1.businessdayssince bdoutstanding,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= compl.sla
               THEN 'Yes'
               ELSE 'No'
           END
       ) withinsla,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= compl.sla
               THEN NULL
               ELSE bds2.businessdayssince - bds1.businessdayssince - compl.sla
           END
       ) bdoverdue
FROM ecl_complaints compl,
     business_days_since_2016 bds1,
     business_days_since_2016 bds2
WHERE to_date (to_char (compl.complaintdate, 'mm') || to_char (compl.complaintdate, 'dd') || to_char (compl.complaintdate, 'yyyy'
), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (sysdate, 'mm') || to_char (sysdate, 'dd') || to_char (sysdate, 'yyyy'), 'MMDDYYYY') = bds2.dateofyear
      (+)
      AND compl.firstinv_date IS NULL