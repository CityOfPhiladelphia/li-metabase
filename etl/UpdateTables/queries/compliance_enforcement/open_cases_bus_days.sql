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
       c.lastcompletedinvdate,
       (
           CASE
               WHEN c.lastcompletedinvdate IS NULL
               THEN NULL
               ELSE trunc (sysdate - c.lastcompletedinvdate)
           END
       ) cdsincelastcomplinv,
       (
           CASE
               WHEN c.lastcompletedinvdate IS NULL
               THEN NULL
               WHEN trunc (sysdate - c.lastcompletedinvdate) <= 45
               THEN '0-45'
               ELSE '45+'
           END
       ) cdsincelastcomplinvcategories,
       (
           CASE
               WHEN c.lastcompletedinvdate IS NULL
               THEN NULL
               ELSE bds1.businessdayssince - bds3.businessdayssince
           END
       ) bdsincelastcomplinv,
       (
           CASE
               WHEN c.lastcompletedinv IS NULL
               THEN NULL
               WHEN bds1.businessdayssince - bds3.businessdayssince <= 45
               THEN '0-45'
               ELSE '45+'
           END
       ) bdsincelastcomplinvcategories,
       c.lastcompletedinvstatus,
       c.lastcompletedinvinvestigator,
       c.nextscheduledinv,
       c.nextscheduledinvdate,
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
       c.overdueinv,
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
FROM open_cases c,
     business_days_since_2007 bds1,
     business_days_since_2007 bds2,
     business_days_since_2007 bds3,
     business_days_since_2007 bds4,
     business_days_since_2007 bds5,
     business_days_since_2007 bds6
WHERE to_date (to_char (sysdate, 'mm') || to_char (sysdate, 'dd') || to_char (sysdate, 'yyyy'), 'MMDDYYYY') = bds1.dateofyear (+)
      AND to_date (to_char (c.createddate, 'mm') || to_char (c.createddate, 'dd') || to_char (c.createddate, 'yyyy'), 'MMDDYYYY')                          =
      bds2.dateofyear (+)
      AND to_date (to_char (c.lastcompletedinvdate, 'mm') || to_char (c.lastcompletedinvdate, 'dd') || to_char (c.lastcompletedinvdate, 'yyyy'
      ), 'MMDDYYYY')   = bds3.dateofyear (+)
      AND to_date (to_char (c.nextscheduledinvdate, 'mm') || to_char (c.nextscheduledinvdate, 'dd') || to_char (c.nextscheduledinvdate, 'yyyy'
      ), 'MMDDYYYY')   = bds4.dateofyear (+)
      AND to_date (to_char (c.overdueinvscheduleddate, 'mm') || to_char (c.overdueinvscheduleddate, 'dd') || to_char (c.overdueinvscheduleddate
      , 'yyyy'), 'MMDDYYYY') = bds5.dateofyear (+)
      AND to_date (to_char (c.completeddate, 'mm') || to_char (c.completeddate, 'dd') || to_char (c.completeddate, 'yyyy'), 'MMDDYYYY'
      )            = bds6.dateofyear (+)
