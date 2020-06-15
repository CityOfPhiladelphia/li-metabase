/* , 
       Not sure how to define business days outstanding or overdue. Was going to do it based
       on the first investigation date, but I'm not sure that's right, especially since, if the
       complaint is linked to an existing casefile, it's possible for the first investigation
       to have happened before the complaint (resulting in negative bdoustanding numbers).
       So should I only look at how long it was b/t the complaint date and the first investigation
       date for complaints that weren't linked to an existing case file? Or should only look at how long
       it was b/t the complaint date and the first investigation date *after* the complaint date?
       Or should I instead look at how long it was b/t the complaint date and the review complaint
       completed date? Just need a better understanding of how the dept is defining SLAs and how they
       want to keep track of overdue/missed complaints.
       For now (06/15/20) I'm just going to define a "business days since complaint" field
       which won't be particularly meaningful for complaints that have been resolved or reached
       whatever point they need to reach in order to not be considered late. But it will be meaningful
       for complaints that haven't reached that point (whatever it is). The user can filter down
       to that point using other filters (review complaint status is incompleted, most recent inv status
       is uninvestigated, etc) and then look at the bdsincecomplaint value to get a sense of how overdue
       this complaint might be.
SELECT complaintjobid,
       complaintnumber,
       address,
       complaintcode,
       complainttype,
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
               WHEN bds2.businessdayssince - bds1.businessdayssince <= 10
               THEN '0-10'
               WHEN bds2.businessdayssince - bds1.businessdayssince BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds2.businessdayssince - bds1.businessdayssince BETWEEN 21 AND 100
               THEN '21-100'
               ELSE 'More than 100'
           END
       ) bdoutstandingcategories,
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
       ) bdoverdue,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= compl.sla
               THEN NULL
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla <= 10
               THEN '0-10'
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla BETWEEN 21 AND 100
               THEN '21-100'
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla > 100
               THEN 'More than 100'
               ELSE NULL
           END
       ) bdoverduecategories
FROM ecl_complaints compl,
     business_days_since_2016 bds1,
     business_days_since_2016 bds2
WHERE to_date (to_char (compl.complaintdate, 'mm') || to_char (compl.complaintdate, 'dd') || to_char (compl.complaintdate, 'yyyy'
), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (compl.firstinv_date, 'mm') || to_char (compl.firstinv_date, 'dd') || to_char (compl.firstinv_date, 'yyyy'
      ), 'MMDDYYYY') = bds2.dateofyear (+)
      AND compl.firstinv_date IS NOT NULL
UNION */
SELECT complaintjobid,
       complaintnumber,
       address,
       complaintcode,
       complainttype,
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
       /*,
       bds2.businessdayssince - bds1.businessdayssince bdoutstanding,
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
       ) bdoutstandingcategories,
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
       ) bdoverdue,
       (
           CASE
               WHEN bds2.businessdayssince - bds1.businessdayssince <= compl.sla
               THEN NULL
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla <= 10
               THEN '0-10'
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla BETWEEN 21 AND 100
               THEN '21-100'
               WHEN bds2.businessdayssince - bds1.businessdayssince - compl.sla > 100
               THEN 'More than 100'
               ELSE NULL
           END
       ) bdoverduecategories */
FROM ecl_complaints compl,
     business_days_since_2016 bds1,
     business_days_since_2016 bds2
WHERE to_date (to_char (compl.complaintdate, 'mm') || to_char (compl.complaintdate, 'dd') || to_char (compl.complaintdate, 'yyyy'
), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (sysdate, 'mm') || to_char (sysdate, 'dd') || to_char (sysdate, 'yyyy'), 'MMDDYYYY') = bds2.dateofyear
      (+)
      --AND compl.firstinv_date IS NULL