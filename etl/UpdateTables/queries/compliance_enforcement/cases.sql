SELECT c.internalid,
       c.casenumber,
       c.casetype,
       c.caseresponsibility,
       c.casepriority,
       c.createddate,
       c.casestatus,
       (
           CASE
               WHEN c.completeddate IS NULL
               THEN bds1.businessdayssince - bds2.businessdayssince
               ELSE bds6.businessdayssince - bds2.businessdayssince
           END
       ) bdopen,
       (
           CASE
               WHEN c.completeddate IS NULL
               THEN (
                   CASE
                       WHEN bds1.businessdayssince - bds2.businessdayssince <= 10
                       THEN '0-10'
                       WHEN bds1.businessdayssince - bds2.businessdayssince BETWEEN 11 AND 20
                       THEN '11-20'
                       WHEN bds1.businessdayssince - bds2.businessdayssince BETWEEN 21 AND 100
                       THEN '21-100'
                       ELSE 'More than 100'
                   END
               )
               ELSE (
                   CASE
                       WHEN bds6.businessdayssince - bds2.businessdayssince <= 10
                       THEN '0-10'
                       WHEN bds6.businessdayssince - bds2.businessdayssince BETWEEN 11 AND 20
                       THEN '11-20'
                       WHEN bds6.businessdayssince - bds2.businessdayssince BETWEEN 21 AND 100
                       THEN '21-100'
                       ELSE 'More than 100'
                   END
               )
           END
       ) bdopencategories,
       c.completeddate,
       c.completed,
       c.investigated,
       c.firstcompletedinv,
       c.firstcompletedinvstatus,
       c.firstcompletedinvinvestigator,
       c.lastcompletedinv,
       (
           CASE
               WHEN c.lastcompletedinv IS NULL
               THEN NULL
               ELSE trunc (sysdate - c.lastcompletedinv)
           END
       ) cdsincelastcomplinv,
       (
           CASE
               WHEN c.lastcompletedinv IS NULL
               THEN NULL
               WHEN trunc (sysdate - c.lastcompletedinv) <= 45
               THEN '0-45'
               ELSE '45+'
           END
       ) cdsinceclastcomplinvcategories,
       (
           CASE
               WHEN c.lastcompletedinv IS NULL
               THEN NULL
               ELSE bds1.businessdayssince - bds3.businessdayssince
           END
       ) bdsincelastcomplinv,
       (
           CASE
               WHEN c.lastcompletedinv IS NULL
               THEN NULL
               WHEN bds1.businessdayssince - bds3.businessdayssince <= 10
               THEN '0-10'
               WHEN bds1.businessdayssince - bds3.businessdayssince BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds1.businessdayssince - bds3.businessdayssince BETWEEN 21 AND 100
               THEN '21-100'
               ELSE 'More than 100'
           END
       ) bdsincelastcomplinvcategories,
       c.lastcompletedinvstatus,
       c.lastcompletedinvinvestigator,
       c.nextscheduledinv,
       (
           CASE
               WHEN c.nextscheduledinv IS NULL
               THEN NULL
               ELSE bds4.businessdayssince - bds1.businessdayssince
           END
       ) bduntilnextscheduledinv,
       (
           CASE
               WHEN c.nextscheduledinv IS NULL
               THEN NULL
               WHEN bds4.businessdayssince - bds1.businessdayssince <= 10
               THEN '0-10'
               WHEN bds4.businessdayssince - bds1.businessdayssince BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds4.businessdayssince - bds1.businessdayssince BETWEEN 21 AND 100
               THEN '21-100'
               ELSE 'More than 100'
           END
       ) bduntilnextschedinvcategories,
       c.nextscheduledinvinvestigator,
       c.overdueinvscheduleddate,
       (
           CASE
               WHEN c.overdueinvscheduleddate IS NULL
               THEN NULL
               ELSE bds1.businessdayssince - bds5.businessdayssince
           END
       ) bdsinceoverdueinv,
       (
           CASE
               WHEN c.overdueinvscheduleddate IS NULL
               THEN NULL
               WHEN bds1.businessdayssince - bds5.businessdayssince <= 10
               THEN '0-10'
               WHEN bds1.businessdayssince - bds5.businessdayssince BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds1.businessdayssince - bds5.businessdayssince BETWEEN 21 AND 100
               THEN '21-100'
               ELSE 'More than 100'
           END
       ) bdsinceoverdueinvcategories,
       c.overdueinvinvestigator,
       c.onlyincludeslicensevios,
       c.address,
       c.zip,
       c.council_district,
       c.li_district,
       c.censustract,
       c.lon,
       c.lat,
       c.systemofrecord
       /*
       (
           CASE
               WHEN bds1.businessdayssince - bds?.businessdayssince <= c.sla
               THEN 'Yes'
               ELSE 'No'
           END
       ) withinsla,
       (
           CASE
               WHEN bds1.businessdayssince - bds?.businessdayssince <= c.sla
               THEN NULL
               ELSE bds1.businessdayssince - bds?.businessdayssince - c.sla
           END
       ) bdoverdue,
       (
           CASE
               WHEN bds1.businessdayssince - bds?.businessdayssince <= c.sla
               THEN NULL
               WHEN bds1.businessdayssince - bds?.businessdayssince - c.sla <= 10
               THEN '0-10'
               WHEN bds1.businessdayssince - bds?.businessdayssince - c.sla BETWEEN 11 AND 20
               THEN '11-20'
               WHEN bds1.businessdayssince - bds?.businessdayssince - c.sla BETWEEN 21 AND 100
               THEN '21-100'
               WHEN bds1.businessdayssince - bds?.businessdayssince - c.sla > 100
               THEN 'More than 100'
               ELSE NULL
           END
       ) bdoverduecategories */
FROM cases_basic c,
     business_days_since_2007 bds1,
     business_days_since_2007 bds2,
     business_days_since_2007 bds3,
     business_days_since_2007 bds4,
     business_days_since_2007 bds5,
     business_days_since_2007 bds6
WHERE to_date (to_char (sysdate, 'mm') || to_char (sysdate, 'dd') || to_char (sysdate, 'yyyy'), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (c.createddate, 'mm') || to_char (c.createddate, 'dd') || to_char (c.createddate, 'yyyy'), 'MMDDYYYY')                          =
      bds2.dateofyear (+)
      AND to_date (to_char (c.lastcompletedinv, 'mm') || to_char (c.lastcompletedinv, 'dd') || to_char (c.lastcompletedinv, 'yyyy'
      ), 'MMDDYYYY')   = bds3.dateofyear (+)
      AND to_date (to_char (c.nextscheduledinv, 'mm') || to_char (c.nextscheduledinv, 'dd') || to_char (c.nextscheduledinv, 'yyyy'
      ), 'MMDDYYYY')   = bds4.dateofyear (+)
      AND to_date (to_char (c.overdueinvscheduleddate, 'mm') || to_char (c.overdueinvscheduleddate, 'dd') || to_char (c.overdueinvscheduleddate
      , 'yyyy'), 'MMDDYYYY') = bds5.dateofyear (+)
      AND to_date (to_char (c.completeddate, 'mm') || to_char (c.completeddate, 'dd') || to_char (c.completeddate, 'yyyy'), 'MMDDYYYY'
      )            = bds6.dateofyear (+)
      --and c.createddate >= '01-JAN-2019'